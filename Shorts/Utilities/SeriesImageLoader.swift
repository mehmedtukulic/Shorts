import SwiftUI

enum SeriesImageType: String {
    case coverComplete = "CoverComplete"
    case coverNoText = "CoverNoText"
    case coverTitle = "CoverTitle"
    case comingSoonCard = "ComingSoonCard"
}

/// Bundle image loader with an in-memory cache.
///
/// `@unchecked Sendable`: the only mutable state is `NSCache`, which is documented as thread-safe, and everything else is immutable.
/// One instance is created in `ShortsApp`  and injected through the environment.

final class SeriesImageLoader: @unchecked Sendable {
    private let cache = NSCache<NSString, UIImage>()

    init(countLimit: Int = 100) {
        cache.countLimit = countLimit
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
