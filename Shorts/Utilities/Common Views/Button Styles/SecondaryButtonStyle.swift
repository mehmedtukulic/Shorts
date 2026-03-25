import SwiftUI

/// Secondary button with customizable fill and foreground color
struct SecondaryButtonStyle: ButtonStyle {
    var icon: String? = nil
    var fill: Color = .white.opacity(0.15)
    var foreground: Color = .white
    var cornerRadius: CGFloat = 14

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
            }
            configuration.label
        }
        .font(.button)
        .foregroundStyle(foreground)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(fill)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { SecondaryButtonStyle() }
    static func secondary(
        icon: String? = nil,
        fill: Color = .white.opacity(0.15),
        foreground: Color = .white,
        cornerRadius: CGFloat = 14
    ) -> SecondaryButtonStyle {
        SecondaryButtonStyle(icon: icon, fill: fill, foreground: foreground, cornerRadius: cornerRadius)
    }
}
