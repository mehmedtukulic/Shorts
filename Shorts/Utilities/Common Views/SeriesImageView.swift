import SwiftUI

struct SeriesImageView: View {
    let slug: String
    let type: SeriesImageType

    var body: some View {
        if let uiImage = SeriesImageLoader.shared.image(for: slug, type: type) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Rectangle()
                .fill(Color.white.opacity(0.06))
        }
    }
}
