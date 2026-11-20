import SwiftUI

struct SeriesDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: SeriesDetailViewModel
    @State private var isDescriptionExpanded = false

    private let coordinateSpace = "DetailScroll"

    init(series: Series,
         myListRepository: any MyListRepositoryProtocol) {
        _viewModel = State(initialValue: SeriesDetailViewModel(series: series,
                                                               myListRepository: myListRepository))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        let offset = geo.frame(in: .named(coordinateSpace)).minY
                        ParallaxHeaderView(
                            series: viewModel.series,
                            scrollOffset: offset
                        )
                    }
                    .frame(height: 420)

                    detailContent(viewModel: viewModel)
                }
            }
            .coordinateSpace(name: coordinateSpace)

            BottomBarView(isInMyList: Binding(
                get: { viewModel.isInMyList },
                set: { viewModel.isInMyList = $0 }
            ))
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Toolbar Buttons

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: SFSymbol.back)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }

    private var shareButton: some View {
        ShareLink(item: String.shareText(viewModel.series.title)) {
            Image(systemName: SFSymbol.share)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }

    // MARK: - Detail Content

    @ViewBuilder
    private func detailContent(viewModel: SeriesDetailViewModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            expandableDescription(viewModel.series.description)
                .padding(.horizontal)

            if !viewModel.series.cast.isEmpty {
                Text(String.starring(viewModel.series.castSummary))
                    .font(.small)
                    .foregroundStyle(.textSecondary)
                    .padding(.horizontal)
            }

            Text(String.episodes(viewModel.series.totalEpisodes))
                .font(.title1)
                .foregroundStyle(.white)
                .padding(.horizontal)

            if viewModel.availableSeasons.count > 1 {
                SeasonPickerView(
                    seasons: viewModel.availableSeasons,
                    selectedSeason: Binding(
                        get: { viewModel.selectedSeason },
                        set: { viewModel.selectedSeason = $0 }
                    )
                )
            }

            EpisodeGridView(
                episodes: viewModel.currentEpisodes,
                seriesSlug: viewModel.series.slug
            )

            Spacer(minLength: 100)
        }
        .padding(.top, 16)
    }

    // MARK: - Expandable Description

    @ViewBuilder
    private func expandableDescription(_ text: String) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Text(text)
                .font(.bodyRegular)
                .foregroundStyle(.white)
                .lineLimit(isDescriptionExpanded ? nil : 3)
                .animation(Motion.fade, value: isDescriptionExpanded)

            if !isDescriptionExpanded {
                Button {
                    withAnimation(Motion.fade) {
                        isDescriptionExpanded = true
                    }
                } label: {
                    Text(String.more)
                        .font(.bodyRegular)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.leading, 24)
                        .background(
                            LinearGradient(
                                colors: [Color.appBackground.opacity(0), Color.appBackground, Color.appBackground],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            }
        }
    }
}
