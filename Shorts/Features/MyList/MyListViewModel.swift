import Foundation

@MainActor
@Observable
final class MyListViewModel {
    var seriesList: [Series] {
        myListRepository.series(from: seriesRepository.allSeries)
    }

    private let myListRepository: any MyListRepositoryProtocol
    private let seriesRepository: any SeriesRepositoryProtocol

    init(myListRepository: any MyListRepositoryProtocol, seriesRepository: any SeriesRepositoryProtocol) {
        self.myListRepository = myListRepository
        self.seriesRepository = seriesRepository
    }

    func remove(_ seriesId: String) {
        myListRepository.remove(seriesId)
    }
}
