import Foundation

enum HomepageSection: String, Codable {
    case hero
    case continueWatching
    case comingSoon
    case mostTrending
    case onlyOnShorts
    case topPicks
    case newOnShorts
}

struct HomepageSectionData: Identifiable {
    let section: HomepageSection
    let series: [Series]
    var id: String { section.rawValue }
}
