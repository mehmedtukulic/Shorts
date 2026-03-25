import SwiftUI

struct HeroCarouselView: View {
    @Binding var currentIndex: Int
    @State private var toastSeriesTitle: String?

    let items: [Series]
    let isInMyList: (String) -> Bool
    let toggleMyList: (String) -> Void

    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 440
    private let focusedScale: CGFloat = 1.08

    var body: some View {
        GeometryReader { outerGeo in
            let screenWidth = outerGeo.size.width

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        GeometryReader { cardGeo in
                            let midX = cardGeo.frame(in: .global).midX
                            let distance = abs(midX - screenWidth / 2)
                            let progress = min(distance / (cardWidth * 0.8), 1.0)
                            let scale = focusedScale - (progress * 0.16)
                            let overlayOpacity = progress * 0.45

                            NavigationLink(value: item) {
                                heroCard(for: item, overlayOpacity: overlayOpacity)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                            .scaleEffect(scale)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.white.opacity(0.5), lineWidth: 0.5)
                            )
                        }
                        .frame(width: cardWidth, height: cardHeight)
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding(
                get: { items.indices.contains(currentIndex) ? items[currentIndex].id : nil },
                set: { newID in
                    if let newID, let idx = items.firstIndex(where: { $0.id == newID }) {
                        currentIndex = idx
                    }
                }
            ))
            .scrollClipDisabled()
            .defaultScrollAnchor(.center)
            .contentMargins(.horizontal, (screenWidth - cardWidth) / 2, for: .scrollContent)
        }
        .frame(height: cardHeight * focusedScale + 16)
        .overlay(alignment: .top) {
            if let toastSeriesTitle {
                Text(toastSeriesTitle)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 8)
            }
        }
    }

    @ViewBuilder
    private func heroCard(for serie: Series, overlayOpacity: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            SeriesImageView(slug: serie.slug, type: .coverComplete)
                .aspectRatio(contentMode: .fill)
                .frame(width: cardWidth, height: cardHeight)
                .clipped()

            Color.black.opacity(overlayOpacity)
                .allowsHitTesting(false)

            HStack(spacing: 10) {
                Button(String.play) {}
                    .buttonStyle(.secondary(icon: SFSymbol.play, fill: .white, foreground: .black))

                myListButton(for: serie)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    private func myListButton(for series: Series) -> some View {
        let isAdded = isInMyList(series.id)
        return Button(isAdded ? String.added : .tabMyList) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                toggleMyList(series.id)
            }
            showToast(for: series, added: !isAdded)
        }
        .buttonStyle(.secondary(
            icon: isAdded ? SFSymbol.checkmark : SFSymbol.plus,
            fill: .gray.opacity(isAdded ? 0.2 : 0.3)
        ))
    }

    private func showToast(for series: Series, added: Bool) {
        let title = added ? String.toastAdded(series.title) : .toastRemoved(series.title)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            toastSeriesTitle = title
        }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeOut(duration: 0.3)) {
                if toastSeriesTitle == title {
                    toastSeriesTitle = nil
                }
            }
        }
    }
}
