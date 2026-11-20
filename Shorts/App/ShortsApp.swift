import SwiftUI

@main
struct ShortsApp: App {
    private let seriesRepository = SeriesRepository()
    private let myListRepository = MyListRepository()
    private let imageLoader = SeriesImageLoader()

    var body: some Scene {
        WindowGroup {
            ContentView(seriesRepository: seriesRepository,
                        myListRepository: myListRepository)
                .environment(\.seriesImageLoader, imageLoader)
                .preferredColorScheme(.dark)
        }
    }
}
