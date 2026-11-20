import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private let repository: any SeriesRepositoryProtocol
    private let myListRepository: any MyListRepositoryProtocol

    var sections: [HomepageSectionData] = []
    var currentHeroIndex: Int = 0
    var isLoading = true
    var error: String? = nil

    init(repository: any SeriesRepositoryProtocol, myListRepository: any MyListRepositoryProtocol) {
        self.repository = repository
        self.myListRepository = myListRepository
    }

    func loadSections() async {
        // Already loaded (e.g. the view re-appeared): keep content, no spinner flash.
        guard sections.isEmpty else { return }

        isLoading = true
        error = nil

        do {
            try await repository.loadData()
            sections = repository.homepageSections
        } catch is CancellationError {
            // The .task owner went away. Not a failure: leave state untouched.
            return
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - My List

    func isInMyList(_ seriesId: String) -> Bool {
        myListRepository.contains(seriesId)
    }

    func toggleMyList(_ seriesId: String) {
        myListRepository.toggle(seriesId)
    }
}
