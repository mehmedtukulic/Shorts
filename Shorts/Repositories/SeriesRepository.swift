import Foundation

// MARK: - Protocol

protocol SeriesRepositoryProtocol: AnyObject {
    var allSeries: [Series] { get }
    var homepageSections: [HomepageSectionData] { get }

    func loadData() async throws
}

// MARK: - Concrete Implementation

final class SeriesRepository: SeriesRepositoryProtocol {
    private(set) var allSeries: [Series] = []
    private(set) var homepageSections: [HomepageSectionData] = []

    func loadData() async throws {
        guard allSeries.isEmpty else { return }

        // Simulate network latency
        try await Task.sleep(for: .milliseconds(600))

        // Decode off main thread
        let result = try await Task.detached(priority: .userInitiated) {
            guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
                throw RepositoryError.fileNotFound
            }

            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(HomepageResponse.self, from: data)

            let sections = decoded.sections
                .filter { !$0.series.isEmpty }
                .map { HomepageSectionData(section: $0.type, series: $0.series) }

            return (decoded.allSeries, sections)
        }.value

        allSeries = result.0
        homepageSections = result.1
    }
}

// MARK: - Errors

enum RepositoryError: LocalizedError {
    case fileNotFound

    var errorDescription: String? {
        switch self {
        case .fileNotFound: "Could not locate data file in bundle."
        }
    }
}
