import SwiftUI

/// Shared layout values. One-off dimensions stay next to the view that owns them;
/// only values used by several screens live here.
enum Layout {
    /// Horizontal inset for full-width content: headers, grids, shelves.
    static let screenPadding: CGFloat = 20

    /// Three-column poster grid used by Search, For You and My List.
    static let posterColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    static let posterGridRowSpacing: CGFloat = 14

    /// Default poster card size (shelves and `SeriesCardView`).
    static let standardCardWidth: CGFloat = 120
    static let standardCardHeight: CGFloat = 170
}

/// Shared animation curves.
enum Motion {
    /// Selection changes, toggles, list edits, tab switches.
    static let selection = Animation.spring(response: 0.3, dampingFraction: 0.8)

    /// Content fades and expand/collapse.
    static let fade = Animation.easeInOut(duration: 0.3)

    /// Small indicator changes (page dots, season picker).
    static let quickFade = Animation.easeInOut(duration: 0.2)
}
