import SwiftUI

/// Liquid glass button for iOS 26+, falls back to ultra-thin material
struct GlassButtonStyle: ButtonStyle {
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
        .padding(.horizontal, 24)
        .frame(height: 48)
        .modifier(GlassButtonBackground())
        .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

private struct GlassButtonBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))
        } else {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }
}

extension ButtonStyle where Self == GlassButtonStyle {
    static var glass: GlassButtonStyle { GlassButtonStyle() }
    static func glass(icon: String) -> GlassButtonStyle {
        GlassButtonStyle(icon: icon)
    }
}
