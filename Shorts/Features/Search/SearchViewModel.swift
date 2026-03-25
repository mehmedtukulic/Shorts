import Foundation

@MainActor
@Observable
final class SearchViewModel {
    var searchText = ""
    var selectedGenres: Set<String> = []

    private let seriesRepository: any SeriesRepositoryProtocol

    init(seriesRepository: any SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }

    var allGenres: [String] {
        Array(Set(seriesRepository.allSeries.flatMap(\.genres))).sorted()
    }

    var filteredSeries: [Series] {
        let query = searchText.lowercased()
        return seriesRepository.allSeries.filter { series in
            let matchesText = query.isEmpty ||
                series.title.lowercased().contains(query) ||
                series.genres.contains { $0.lowercased().contains(query) } ||
                series.cast.contains { $0.lowercased().contains(query) }
            let matchesGenre = selectedGenres.isEmpty ||
                !selectedGenres.isDisjoint(with: series.genres)
            return matchesText && matchesGenre
        }
    }

    var trendingSeries: [Series] {
        seriesRepository.allSeries.filter(\.isTrending)
    }

    var hasActiveFilters: Bool {
        !searchText.isEmpty || !selectedGenres.isEmpty
    }

    func toggleGenre(_ genre: String) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
    }

    func clearSearch() {
        searchText = ""
    }
}
