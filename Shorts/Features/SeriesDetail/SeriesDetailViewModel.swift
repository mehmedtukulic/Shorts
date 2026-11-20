import Foundation

@MainActor
@Observable
final class SeriesDetailViewModel {
    let series: Series
    var selectedSeason: Int

    private let myListRepository: any MyListRepositoryProtocol

    init(series: Series, myListRepository: any MyListRepositoryProtocol) {
        self.series = series
        self.myListRepository = myListRepository
        self.selectedSeason = series.seasons.first?.id ?? 1
    }

    var isInMyList: Bool {
        get { myListRepository.contains(series.id) }
        set { myListRepository.set(series.id, listed: newValue) }
    }

    var currentEpisodes: [Episode] {
        guard let season = series.seasons.first(where: { $0.id == selectedSeason }) else {
            return []
        }
        return season.episodes
    }

    var availableSeasons: [Int] {
        series.seasons.map(\.id)
    }
}
