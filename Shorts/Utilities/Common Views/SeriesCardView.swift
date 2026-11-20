import SwiftUI

struct SeriesCardView: View {
    let series: Series
    var width: CGFloat = Layout.standardCardWidth
    var height: CGFloat = Layout.standardCardHeight

    var body: some View {
        NavigationLink(value: series) {
            SeriesImageView(slug: series.slug, type: .coverComplete)
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .cardStyle()
        }
    }
}
