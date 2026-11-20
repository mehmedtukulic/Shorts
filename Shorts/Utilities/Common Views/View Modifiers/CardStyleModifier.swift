import SwiftUI

struct CardStyleModifier: ViewModifier {
    var cornerRadius: CGFloat = CardStyle.cornerRadius
    var bordered: Bool = true

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)
        content
            .clipShape(shape)
            .overlay {
                if bordered {
                    shape.strokeBorder(CardStyle.borderColor, lineWidth: CardStyle.borderWidth)
                }
            }
    }
}

/// Design tokens for cards.
enum CardStyle {
    static let cornerRadius: CGFloat = 8
    static let borderWidth: CGFloat = 0.5
    static let borderColor = Color.white.opacity(0.5)
}

extension View {
    func cardStyle(cornerRadius: CGFloat = CardStyle.cornerRadius, bordered: Bool = true) -> some View {
        modifier(CardStyleModifier(cornerRadius: cornerRadius, bordered: bordered))
    }
}
