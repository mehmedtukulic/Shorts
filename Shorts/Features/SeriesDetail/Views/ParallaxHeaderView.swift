import SwiftUI

struct ParallaxHeaderView: View {
    let series: Series
    let scrollOffset: CGFloat

    private let headerHeight: CGFloat = 420

    private var parallaxOffset: CGFloat {
        scrollOffset < 0 ? scrollOffset * 0.5 : 0
    }

    private var stretchHeight: CGFloat {
        scrollOffset > 0 ? headerHeight + scrollOffset : headerHeight
    }

    private var titleOpacity: Double {
        let fadeStart: CGFloat = -50
        let fadeEnd: CGFloat = -150
        if scrollOffset >= fadeStart { return 1 }
        if scrollOffset <= fadeEnd { return 0 }
        return Double((scrollOffset - fadeEnd) / (fadeStart - fadeEnd))
    }

    private var titleScale: CGFloat {
        let scale = 1.0 + min(0, scrollOffset) / 500.0
        return max(0.7, scale)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            SeriesImageView(slug: series.slug, type: .coverNoText)
                .aspectRatio(contentMode: .fill)
                .frame(height: stretchHeight)
                .offset(y: scrollOffset > 0 ? -scrollOffset : parallaxOffset)
                .clipped()

            LinearGradient(
                colors: [
                    .clear,
                    .clear,
                    Color.appBackground.opacity(0.5),
                    Color.appBackground
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 6) {
                SeriesImageView(slug: series.slug, type: .coverTitle)
                    .aspectRatio(1248.0 / 810.0, contentMode: .fit)
                    .frame(maxWidth: 280)
                    .scaleEffect(titleScale)

                Text(series.genreBreadcrumb)
                    .font(.captionMedium)
                    .foregroundStyle(.white)
            }
            .opacity(titleOpacity)
            .padding(.bottom, 20)
        }
        .frame(height: stretchHeight)
        .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
    }
}
