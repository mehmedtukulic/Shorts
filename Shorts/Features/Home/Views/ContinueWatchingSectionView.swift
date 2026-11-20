import SwiftUI

struct ContinueWatchingSectionView: View {
    let items: [Series]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: .continueWatching)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            VStack(alignment: .leading, spacing: 6) {
                                coverImage(for: item)

                                Text(item.title)
                                    .font(.small)
                                    .foregroundStyle(.white)
                                    .lineLimit(2)
                                    .frame(width: 112, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private func coverImage(for item: Series) -> some View {
        SeriesImageView(slug: item.slug, type: .coverComplete)
            .aspectRatio(contentMode: .fill)
            .frame(width: 112, height: 158)
            .overlay {
                LinearGradient(
                    colors: [.clear, .clear, .black.opacity(0.4), .black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .overlay {
                Image(systemName: SFSymbol.playCircle)
                    .font(.system(size: 32))
                    .foregroundStyle(.accentPink)
                    .shadow(color: .black.opacity(0.4), radius: 4)
            }
            .overlay(alignment: .bottom) {
                if let watched = item.watchedEpisodes {
                    VStack(spacing: 4) {
                        Text(String.episodeProgress(watched, item.totalEpisodes))
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)

                        GeometryReader { geo in
                            let progress = CGFloat(watched) / CGFloat(max(item.totalEpisodes, 1))
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.white.opacity(0.3))
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.accentPink)
                                    .frame(width: geo.size.width * progress)
                            }
                        }
                        .frame(height: 3)
                        .padding(.horizontal, 8)
                    }
                    .padding(.bottom, 6)
                }
            }
            .cardStyle()
    }
}
