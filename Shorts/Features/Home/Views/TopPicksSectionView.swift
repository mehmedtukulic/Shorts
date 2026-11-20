import SwiftUI

struct TopPicksSectionView: View {
    @State private var showAll = false
    let items: [Series]

    private var displayedItems: [Series] {
        showAll ? items : Array(items.prefix(4))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(
                title: .topPicks,
                showViewAll: !showAll
            ) {
                withAnimation { showAll = true }
            }

            VStack(spacing: 12) {
                ForEach(displayedItems) { item in
                    NavigationLink(value: item) {
                        topPickRow(item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func topPickRow(_ serie: Series) -> some View {
        HStack(spacing: 12) {
            SeriesImageView(slug: serie.slug, type: .coverComplete)
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 110)
                .cardStyle(bordered: false)

            VStack(alignment: .leading, spacing: 6) {
                Text(serie.title)
                    .font(.bodyMedium)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(String.episodesCount(serie.totalEpisodes))
                    .font(.small)
                    .foregroundStyle(.accentPink)

                HStack(spacing: 4) {
                    ForEach(serie.genres.prefix(3), id: \.self) { genre in
                        Text(genre)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.tagBackground, in: Capsule())
                    }
                }
            }

            Spacer()

            Image(systemName: SFSymbol.playCircle)
                .font(.system(size: 28))
                .foregroundStyle(.accentPink)
        }
    }
}
