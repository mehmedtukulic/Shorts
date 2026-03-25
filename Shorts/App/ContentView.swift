import SwiftUI

struct ContentView: View {
    @Environment(\.seriesRepository) private var seriesRepository
    @Environment(\.myListRepository) private var myListRepository
    @Environment(\.tabBarVisibility) private var tabBarVisibility

    @State private var selectedTab: AppTab = .library
    @State private var showSearch = false
    @State private var searchButtonCenter: CGPoint = .zero

    private var searchAnchor: UnitPoint {
        let screen = UIScreen.main.bounds
        guard searchButtonCenter != .zero else {
            return UnitPoint(x: 0.92, y: 0.92)
        }
        return UnitPoint(
            x: searchButtonCenter.x / screen.width,
            y: searchButtonCenter.y / screen.height
        )
    }

    var body: some View {
        ZStack {
            mainContent
                .blur(radius: showSearch ? 10 : 0)
                .scaleEffect(showSearch ? 0.94 : 1)
                .allowsHitTesting(!showSearch)

            SearchView(isPresented: $showSearch, seriesRepository: seriesRepository)
                .clipShape(RoundedRectangle(cornerRadius: showSearch ? 24 : 29, style: .continuous))
                .shadow(color: .black.opacity(showSearch ? 0.3 : 0), radius: 20, y: 8)
                .padding(showSearch ? 4 : 0)
                .scaleEffect(showSearch ? 1 : 0.001, anchor: searchAnchor)
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
                NavigationStack {
                    HomeView(repository: seriesRepository, myListRepository: myListRepository)
                        .onAppear { tabBarVisibility.isVisible = true }
                        .navigationDestination(for: Series.self) { series in
                            SeriesDetailView(series: series, myListRepository: myListRepository)
                        }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.library)

                NavigationStack {
                    ForYouView(seriesRepository: seriesRepository, myListRepository: myListRepository)
                        .onAppear { tabBarVisibility.isVisible = true }
                        .navigationDestination(for: Series.self) { series in
                            SeriesDetailView(series: series, myListRepository: myListRepository)
                        }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.forYou)

                NavigationStack {
                    MyListView(myListRepository: myListRepository, seriesRepository: seriesRepository)
                        .onAppear { tabBarVisibility.isVisible = true }
                        .navigationDestination(for: Series.self) { series in
                            SeriesDetailView(series: series, myListRepository: myListRepository)
                        }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.myList)

                NavigationStack {
                    RewardsView()
                        .onAppear { tabBarVisibility.isVisible = true }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(AppTab.rewards)
            }

            if tabBarVisibility.isVisible {
                MainTabBar(selectedTab: $selectedTab, showSearch: $showSearch)
                    .padding(.bottom, -22)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: tabBarVisibility.isVisible)
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
