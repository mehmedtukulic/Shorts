import SwiftUI

// MARK: - Series Image Loader

private struct SeriesImageLoaderKey: EnvironmentKey {
    /// No default instance: a missing injection must be visible, not silently get its own cache.
    static let defaultValue: SeriesImageLoader? = nil
}

// MARK: - Environment Access

extension EnvironmentValues {
    var seriesImageLoader: SeriesImageLoader? {
        get { self[SeriesImageLoaderKey.self] }
        set { self[SeriesImageLoaderKey.self] = newValue }
    }
}
