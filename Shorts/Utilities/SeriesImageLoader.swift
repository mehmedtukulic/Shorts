import SwiftUI

enum SeriesImageType: String {
    case coverComplete = "CoverComplete"
    case coverNoText = "CoverNoText"
    case coverTitle = "CoverTitle"
    case comingSoonCard = "ComingSoonCard"
}

final class SeriesImageLoader {
    static let shared = SeriesImageLoader()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100
    }

    func image(for slug: String, type: SeriesImageType) -> UIImage? {
        let cacheKey = NSString(string: "\(slug)/\(type.rawValue)")

        if let cached = cache.object(forKey: cacheKey) {
            return cached
        }

        guard let loaded = loadFromBundle(slug: slug, type: type) else {
            return nil
        }

        cache.setObject(loaded, forKey: cacheKey)
        return loaded
    }

    private func loadFromBundle(slug: String, type: SeriesImageType) -> UIImage? {
        for ext in ["jpg", "png"] {
            if let url = Bundle.main.url(
                forResource: type.rawValue,
                withExtension: ext,
                subdirectory: "SeriesCovers/\(slug)"
            ) {
                return UIImage(contentsOfFile: url.path)
            }
        }

        if let bundlePath = Bundle.main.resourcePath {
            let dir = "\(bundlePath)/SeriesCovers/\(slug)"
            for ext in ["jpg", "png"] {
                let filePath = "\(dir)/\(type.rawValue).\(ext)"
                if FileManager.default.fileExists(atPath: filePath) {
                    return UIImage(contentsOfFile: filePath)
                }
            }
        }

        return nil
    }
}
