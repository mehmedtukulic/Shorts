import SwiftUI

struct ShortsLogoView: View {
    var compact: Bool = false

    var body: some View {
        HStack(spacing: compact ? 4 : 6) {
            AppIcon.logo
                .resizable()
                .scaledToFit()
                .frame(height: compact ? 18 : 28)
            if !compact {
                Text(String.appName)
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(.white)
            }
        }
    }
}
