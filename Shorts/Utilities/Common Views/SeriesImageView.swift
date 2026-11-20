import SwiftUI

struct SeriesImageView: View {
    @Environment(\.seriesImageLoader) private var imageLoader

    let slug: String
    let type: SeriesImageType

    var body: some View {
        if let uiImage = loadImage() {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Rectangle()
                .fill(Color.white.opacity(0.06))
        }
    }

    private func loadImage() -> UIImage? {
        guard let imageLoader else {
            assertionFailure("SeriesImageLoader missing from the environment")
            return nil
        }
        return imageLoader.image(for: slug, type: type)
    }
}
