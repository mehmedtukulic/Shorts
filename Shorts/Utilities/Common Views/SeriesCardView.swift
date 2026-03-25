import SwiftUI

struct SeriesCardView: View {
    let series: Series
    var width: CGFloat = 120
    var height: CGFloat = 170

    var body: some View {
        NavigationLink(value: series) {
            SeriesImageView(slug: series.slug, type: .coverComplete)
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.white.opacity(0.5), lineWidth: 0.5)
                )
        }
    }
}
