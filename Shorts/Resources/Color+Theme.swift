import SwiftUI

extension Color {
    static let appBackground = Color("appBackground")
    static let accentPink = Color("accentPink")
    static let textSecondary = Color("textSecondary")
    static let tagBackground = Color("tagBackground")
}

extension ShapeStyle where Self == Color {
    static var appBackground: Color { .appBackground }
    static var accentPink: Color { .accentPink }
    static var textSecondary: Color { .textSecondary }
    static var tagBackground: Color { .tagBackground }
}
