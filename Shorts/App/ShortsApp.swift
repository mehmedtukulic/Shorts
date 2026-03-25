import SwiftUI

@main
struct ShortsApp: App {
    private let seriesRepository = SeriesRepository()
    private let myListRepository = MyListRepository()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.seriesRepository, seriesRepository)
                .environment(\.myListRepository, myListRepository)
                .preferredColorScheme(.dark)
        }
    }
}
