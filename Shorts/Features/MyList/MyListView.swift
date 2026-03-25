import SwiftUI

struct MyListView: View {
    @State private var viewModel: MyListViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(myListRepository: any MyListRepositoryProtocol,
         seriesRepository: any SeriesRepositoryProtocol) {
        _viewModel = State(initialValue: MyListViewModel(
            myListRepository: myListRepository,
            seriesRepository: seriesRepository
        ))
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            if viewModel.seriesList.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(String.myListTitle)
                            .font(.heading)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(viewModel.seriesList) { series in
                                seriesCard(series)
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }

    private func seriesCard(_ series: Series) -> some View {
        NavigationLink(value: series) {
            SeriesImageView(slug: series.slug, type: .coverComplete)
                .aspectRatio(2/3, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topTrailing) {
                    removeButton(series)
                }
        }
    }

    private func removeButton(_ series: Series) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                viewModel.remove(series.id)
            }
        } label: {
            Image(systemName: SFSymbol.close)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(.black.opacity(0.6))
                .clipShape(Circle())
        }
        .padding(6)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: SFSymbol.heartSlash)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(String.myListEmptyTitle)
                .font(.title1)
                .foregroundStyle(.white)
            Text(String.myListEmptySubtitle)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
