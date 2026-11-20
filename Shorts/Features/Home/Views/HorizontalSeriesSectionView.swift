import SwiftUI

struct HorizontalSeriesSectionView: View {
    let title: String
    let items: [Series]
    var cardWidth: CGFloat = Layout.standardCardWidth
    var cardHeight: CGFloat = Layout.standardCardHeight
    var showRanking: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        if showRanking {
                            rankedCard(item, rank: index + 1)
                        } else {
                            SeriesCardView(
                                series: item,
                                width: cardWidth,
                                height: cardHeight
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private func rankedCard(_ item: Series, rank: Int) -> some View {
        NavigationLink(value: item) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .bottom, spacing: -8) {
                    Text("\(rank)")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                        .frame(width: 40, alignment: .trailing)
                        .offset(y: 8)

                    SeriesImageView(slug: item.slug, type: .coverComplete)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardHeight)
                        .cardStyle()
                        .overlay(alignment: .topTrailing) {
                            Text(String.hot)
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.accentPink, in: Capsule())
                                .padding(6)
                        }
                }

                // View count
                if let views = item.viewCount {
                    HStack(spacing: 4) {
                        Image(systemName: SFSymbol.play)
                            .font(.system(size: 10))
                        Text(views)
                            .font(.small)
                    }
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.leading, 32)
                }

                Text(item.title)
                    .font(.small)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(width: cardWidth, alignment: .leading)
                    .padding(.leading, 32)
            }
        }
        .buttonStyle(.plain)
    }
}
