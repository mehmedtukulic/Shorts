import Foundation

struct Series: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let slug: String
    let description: String
    let genres: [String]
    let totalEpisodes: Int
    let seasons: [Season]
    let cast: [String]
    let isTrending: Bool
    let isNew: Bool
    let isExclusive: Bool
    let isComingSoon: Bool
    let watchedEpisodes: Int?
    let viewCount: String?
    let releaseDate: String?

    var seasonCount: Int { seasons.count }

    var genreBreadcrumb: String {
        genres.joined(separator: " · ")
    }

    var castSummary: String {
        cast.joined(separator: ", ")
    }
}

struct Season: Codable, Hashable, Identifiable {
    let id: Int
    let episodes: [Episode]
}

struct Episode: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let duration: String
}
