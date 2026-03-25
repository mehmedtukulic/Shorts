import SwiftUI

/// Applies native iOS 26 liquid glass effect in a capsule shape,
/// falling back to ultra-thin material on older versions.
struct LiquidGlassCapsuleModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular.interactive(), in: .capsule)
        } else {
            content
                .background(.ultraThinMaterial, in: Capsule())
        }
    }
}

/// Applies native iOS 26 liquid glass effect in a circle shape,
/// falling back to ultra-thin material on older versions.
struct LiquidGlassCircleModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular.interactive(), in: .circle)
        } else {
            content
                .background(.ultraThinMaterial, in: Circle())
        }
    }
}
