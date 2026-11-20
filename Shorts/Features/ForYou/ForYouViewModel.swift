import Foundation

@MainActor
@Observable
final class ForYouViewModel {
    var recommendedSeries: [Series] = []
    var becauseYouWatched: [Series] = []
    var isLoaded = false

    private let seriesRepository: any SeriesRepositoryProtocol
    private let myListRepository: any MyListRepositoryProtocol

    init(seriesRepository: any SeriesRepositoryProtocol,
         myListRepository: any MyListRepositoryProtocol) {
        self.seriesRepository = seriesRepository
        self.myListRepository = myListRepository
    }

    func loadRecommendations() {
        guard !isLoaded else { return }

        let allSeries = seriesRepository.allSeries
        // Repository hasn't loaded yet: stay retryable instead of latching an empty result.
        guard !allSeries.isEmpty else { return }
        isLoaded = true

        let userGenres = collectUserGenres()

        // Recommend series matching user's genres, excluding what they already watch/saved
        let myListIDs = Set(myListRepository.series(from: allSeries).map(\.id))
        let continueWatchingIDs = continueWatchingSeriesIDs()

        let excludedIDs = myListIDs.union(continueWatchingIDs)

        recommendedSeries = allSeries
            .filter { !excludedIDs.contains($0.id) }
            .sorted { lhs, rhs in
                let lhsScore = genreMatchScore(lhs, userGenres: userGenres)
                let rhsScore = genreMatchScore(rhs, userGenres: userGenres)
                return lhsScore > rhsScore
            }
            .prefix(12)
            .map { $0 }

        // "Because you watched" — pick from continue watching and find similar
        let watched = continueWatchingSeries()
        if let seed = watched.first {
            let seedGenres = Set(seed.genres)
            becauseYouWatched = allSeries
                .filter { $0.id != seed.id && !excludedIDs.contains($0.id) }
                .filter { !Set($0.genres).isDisjoint(with: seedGenres) }
                .prefix(8)
                .map { $0 }
        }
    }

    // MARK: - Private

    private func collectUserGenres() -> [String: Int] {
        var genreCounts: [String: Int] = [:]

        let watched = continueWatchingSeries()
        let myList = myListRepository.series(from: seriesRepository.allSeries)

        for series in watched + myList {
            for genre in series.genres {
                genreCounts[genre, default: 0] += 1
            }
        }

        return genreCounts
    }

    private func genreMatchScore(_ series: Series, userGenres: [String: Int]) -> Int {
        series.genres.reduce(0) { $0 + (userGenres[$1] ?? 0) }
    }

    private func continueWatchingSeries() -> [Series] {
        guard let section = seriesRepository.homepageSections.first(where: { $0.section == .continueWatching }) else {
            return []
        }
        return section.series
    }

    private func continueWatchingSeriesIDs() -> Set<String> {
        Set(continueWatchingSeries().map(\.id))
    }
}
