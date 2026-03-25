import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(repository: any SeriesRepositoryProtocol,
         myListRepository: any MyListRepositoryProtocol) {
        _viewModel = State(initialValue: HomeViewModel(repository: repository,
                                                       myListRepository: myListRepository))
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
                    .tint(.accentPink)
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        Color.clear.frame(height: 24)

                        ForEach(viewModel.sections) { sectionData in
                            sectionView(for: sectionData)
                        }

                        Spacer(minLength: 20)
                    }
                }
            }

            headerOverlay
        }
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
        .task {
            await viewModel.loadSections()
        }
    }

    // MARK: - Section Router

    @ViewBuilder
    private func sectionView(for data: HomepageSectionData) -> some View {
        switch data.section {
        case .hero:
            HeroCarouselView(
                currentIndex: $viewModel.currentHeroIndex,
                items: data.series,
                isInMyList: viewModel.isInMyList,
                toggleMyList: viewModel.toggleMyList
            )
        case .continueWatching:
            ContinueWatchingSectionView(items: data.series)
        case .comingSoon:
            ComingSoonCarouselView(items: data.series)
        case .mostTrending:
            HorizontalSeriesSectionView(
                title: .mostTrending,
                items: data.series,
                showRanking: true
            )
        case .onlyOnShorts:
            HorizontalSeriesSectionView(
                title: .onlyOnShorts,
                items: data.series,
                cardWidth: 150,
                cardHeight: 210
            )
        case .topPicks:
            TopPicksSectionView(items: data.series)
        case .newOnShorts:
            HorizontalSeriesSectionView(
                title: .newOnShorts,
                items: data.series
            )
        }
    }

    // MARK: - Header

    private var headerOverlay: some View {
        HStack {
            ShortsLogoView()
            Spacer()
            Button {} label: {
                Image(systemName: SFSymbol.person)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .modifier(LiquidGlassCircleModifier())
            }
        }
        .padding(.horizontal)
        .padding(.top, 4)
        .padding(.bottom, 8)
        .background(
            LinearGradient(
                colors: [Color.appBackground, Color.appBackground.opacity(0.8), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
        )
    }
}
