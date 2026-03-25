import SwiftUI

extension Font {
    /// 28 bold — page headings (My List, placeholder titles)
    static let heading = Font.system(size: 28, weight: .bold)

    /// 24 bold — sheet/modal headings
    static let title2 = Font.system(size: 24, weight: .bold)

    /// 20 bold — section headings, episode numbers
    static let title1 = Font.system(size: 20, weight: .bold)

    /// 16 bold — buttons, CTAs, prominent labels
    static let button = Font.system(size: 16, weight: .bold)

    /// 15 semibold — emphasized body text, option titles
    static let bodyMedium = Font.system(size: 15, weight: .semibold)

    /// 15 regular — body text, descriptions
    static let body = Font.system(size: 15, weight: .regular)

    /// 13 medium — captions, filter chips, small labels
    static let caption = Font.system(size: 13, weight: .medium)

    /// 12 medium — tags, timestamps, tiny labels
    static let small = Font.system(size: 12, weight: .medium)
}
