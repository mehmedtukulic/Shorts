import Foundation

struct HomepageResponse: Codable {
    let sections: [HomepageSectionResponse]
    let allSeries: [Series]
}

struct HomepageSectionResponse: Codable {
    let type: HomepageSection
    let series: [Series]
}
