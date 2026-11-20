import SwiftUI

struct ForYouView: View {
    @State private var viewModel: ForYouViewModel

    init(seriesRepository: any SeriesRepositoryProtocol,
         myListRepository: any MyListRepositoryProtocol) {
        _viewModel = State(initialValue: ForYouViewModel(
            seriesRepository: seriesRepository,
            myListRepository: myListRepository
        ))
    }

    private let columns = Layout.posterColumns

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    Color.clear.frame(height: 56)

                    Text(String.forYouSubtitle)
                        .font(.bodyRegular)
                        .foregroundStyle(.textSecondary)
                        .padding(.horizontal, Layout.screenPadding)

                    if !viewModel.recommendedSeries.isEmpty {
                        LazyVGrid(columns: columns, spacing: Layout.posterGridRowSpacing) {
                            ForEach(viewModel.recommendedSeries) { series in
                                NavigationLink(value: series) {
                                    SeriesImageView(slug: series.slug, type: .coverComplete)
                                        .aspectRatio(2/3, contentMode: .fill)
                                        .cardStyle()
                                }
                            }
                        }
                        .padding(.horizontal, Layout.screenPadding)
                    }

                    // Because you watched
                    if !viewModel.becauseYouWatched.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(String.forYouBecause)
                                .font(.title1)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Layout.screenPadding)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 10) {
                                    ForEach(viewModel.becauseYouWatched) { series in
                                        NavigationLink(value: series) {
                                            VStack(spacing: 6) {
                                                SeriesImageView(slug: series.slug, type: .coverComplete)
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 140, height: 200)
                                                    .cardStyle()

                                                Text(series.title)
                                                    .font(.small)
                                                    .foregroundStyle(.white)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: 140)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, Layout.screenPadding)
                            }
                        }
                    }

                    Spacer(minLength: 100)
                }
            }

            headerOverlay
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadRecommendations()
        }
    }

    private var headerOverlay: some View {
        HStack {
            Text(String.tabForYou)
                .font(.heading)
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal, Layout.screenPadding)
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
