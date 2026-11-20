import SwiftUI

struct ContentView: View {
    private let seriesRepository: any SeriesRepositoryProtocol
    private let myListRepository: any MyListRepositoryProtocol

    @State private var selectedTab: AppTab = .library
    @State private var libraryPath: [Series] = []
    @State private var forYouPath: [Series] = []
    @State private var myListPath: [Series] = []
    @State private var searchPath: [Series] = []
    @State private var showSearch = false
    @State private var searchButtonCenter: CGPoint = .zero

    init(seriesRepository: any SeriesRepositoryProtocol,
         myListRepository: any MyListRepositoryProtocol) {
        self.seriesRepository = seriesRepository
        self.myListRepository = myListRepository
    }

    /// The tab bar is shown only while no detail screen is pushed on the visible stack.
    /// Derived from navigation state, so it can't get out of sync with what is on screen.
    private var isTabBarVisible: Bool {
        guard searchPath.isEmpty else { return false }
        switch selectedTab {
        case .library: return libraryPath.isEmpty
        case .forYou: return forYouPath.isEmpty
        case .myList: return myListPath.isEmpty
        case .rewards, .search: return true
        }
    }

    /// Where the search overlay grows from, as a unit point of the container it fills.
    private func searchAnchor(in container: CGRect) -> UnitPoint {
        guard searchButtonCenter != .zero, container.width > 0, container.height > 0 else {
            return UnitPoint(x: 0.92, y: 0.92)
        }
        return UnitPoint(
            x: (searchButtonCenter.x - container.minX) / container.width,
            y: (searchButtonCenter.y - container.minY) / container.height
        )
    }

    var body: some View {
        GeometryReader { proxy in
            rootContent(container: proxy.frame(in: .global))
        }
    }

    private func rootContent(container: CGRect) -> some View {
        ZStack {
            mainContent
                .blur(radius: showSearch ? 10 : 0)
                .scaleEffect(showSearch ? 0.94 : 1)
                .allowsHitTesting(!showSearch)

            SearchView(isPresented: $showSearch,
                       path: $searchPath,
                       seriesRepository: seriesRepository,
                       myListRepository: myListRepository)
                .clipShape(RoundedRectangle(cornerRadius: showSearch ? 24 : 29, style: .continuous))
                .shadow(color: .black.opacity(showSearch ? 0.3 : 0), radius: 20, y: 8)
                .padding(showSearch ? 4 : 0)
                .scaleEffect(showSearch ? 1 : 0.001, anchor: searchAnchor(in: container))
                .opacity(showSearch ? 1 : 0)
                .allowsHitTesting(showSearch)
                .zIndex(2)
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.88), value: showSearch)
        .onPreferenceChange(SearchButtonCenterKey.self) { searchButtonCenter = $0 }
    }

    // MARK: - Main Content

    private var mainContent: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $libraryPath) {
                    HomeView(repository: seriesRepository, myListRepository: myListRepository)
                        .navigationDestination(for: Series.self) { series in
                            SeriesDetailView(series: series, myListRepository: myListRepository)
                        }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.library)

                NavigationStack(path: $forYouPath) {
                    ForYouView(seriesRepository: seriesRepository, myListRepository: myListRepository)
                        .navigationDestination(for: Series.self) { series in
                            SeriesDetailView(series: series, myListRepository: myListRepository)
                        }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.forYou)

                NavigationStack(path: $myListPath) {
                    MyListView(myListRepository: myListRepository, seriesRepository: seriesRepository)
                        .navigationDestination(for: Series.self) { series in
                            SeriesDetailView(series: series, myListRepository: myListRepository)
                        }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.myList)

                NavigationStack {
                    RewardsView()
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.rewards)
            }

            if isTabBarVisible {
                MainTabBar(selectedTab: $selectedTab, showSearch: $showSearch)
                    .padding(.bottom, -22)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isTabBarVisible)
    }

    @ViewBuilder
    private func placeholderView(_ title: String) -> some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Text(title)
                .font(.heading)
                .foregroundStyle(.white)
        }
    }
}
