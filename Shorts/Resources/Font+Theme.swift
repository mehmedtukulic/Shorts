import SwiftUI

/// App type scale.
///
/// Every token maps to a system text style, so it scales with Dynamic Type. At the default
/// size category the sizes match the design (28 / 22 / 20 / 16 / 15 / 15 / 13 / 12).
/// Names deliberately avoid `Font.body`, `Font.title2` and `Font.caption`, which are
/// built-in SwiftUI styles; redefining them would shadow the system fonts.
extension Font {
    /// 28 bold, page headings (My List, placeholder titles)
    static let heading = Font.title.weight(.bold)

    /// 22 bold, sheet/modal headings
    static let titleLarge = Font.title2.weight(.bold)

    /// 20 bold, section headings, episode numbers
    static let title1 = Font.title3.weight(.bold)

    /// 16 bold, buttons, CTAs, prominent labels
    static let button = Font.callout.weight(.bold)

    /// 15 semibold, emphasized body text, option titles
    static let bodyMedium = Font.subheadline.weight(.semibold)

    /// 15 regular, body text, descriptions
    static let bodyRegular = Font.subheadline

    /// 13 medium, captions, filter chips, small labels
    static let captionMedium = Font.footnote.weight(.medium)

    /// 12 medium, tags, timestamps, tiny labels
    static let small = Font.caption.weight(.medium)
}
