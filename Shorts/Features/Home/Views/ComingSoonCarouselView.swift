import SwiftUI

struct ComingSoonCarouselView: View {
    @State private var currentIndex = 0

    let items: [Series]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeaderView(title: .comingSoon)
                .padding(.bottom, 12)

            TabView(selection: $currentIndex) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    comingSoonCard(for: item)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 200)

            HStack(spacing: 6) {
                ForEach(0..<items.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
            .animation(.easeInOut(duration: 0.2), value: currentIndex)
        }
    }

    @ViewBuilder
    private func comingSoonCard(for item: Series) -> some View {
        NavigationLink(value: item) {
            SeriesImageView(slug: item.slug, type: .comingSoonCard)
                .aspectRatio(2 / 1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [.clear, .clear, .black.opacity(0.5), .black.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 8) {
                        if let releaseDate = item.releaseDate {
                            Text(releaseDate)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.white.opacity(0.15), in: Capsule())
                        }

                        Text(item.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(16)
                }
                .overlay(alignment: .topTrailing) {
                    Button {} label: {
                        Image(systemName: SFSymbol.bell)
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}
