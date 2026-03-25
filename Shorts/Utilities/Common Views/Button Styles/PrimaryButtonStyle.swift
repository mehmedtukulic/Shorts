import SwiftUI

/// Primary pink CTA button
struct PrimaryButtonStyle: ButtonStyle {
    var icon: String? = nil

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
            }
            configuration.label
        }
        .font(.button)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.accentPink)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    static func primary(icon: String) -> PrimaryButtonStyle {
        PrimaryButtonStyle(icon: icon)
    }
}
