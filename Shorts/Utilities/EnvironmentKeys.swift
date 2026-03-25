import SwiftUI

// MARK: - Series Repository

private struct SeriesRepositoryKey: EnvironmentKey {
    static let defaultValue: any SeriesRepositoryProtocol = SeriesRepository()
}

// MARK: - MyList Repository

private struct MyListRepositoryKey: EnvironmentKey {
    static let defaultValue: any MyListRepositoryProtocol = MyListRepository()
}

// MARK: - Tab Bar Visibility

@Observable
final class TabBarVisibility {
    var isVisible = true
}

private struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue = TabBarVisibility()
}

// MARK: - Environment Access

extension EnvironmentValues {
    var seriesRepository: any SeriesRepositoryProtocol {
        get { self[SeriesRepositoryKey.self] }
        set { self[SeriesRepositoryKey.self] = newValue }
    }

    var myListRepository: any MyListRepositoryProtocol {
        get { self[MyListRepositoryKey.self] }
        set { self[MyListRepositoryKey.self] = newValue }
    }

    var tabBarVisibility: TabBarVisibility {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}
