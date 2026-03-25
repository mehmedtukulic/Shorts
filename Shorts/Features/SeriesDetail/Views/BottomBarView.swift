import SwiftUI

struct BottomBarView: View {
    @Binding var isInMyList: Bool

    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [.clear, Color.appBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 30)

            HStack(spacing: 12) {
                Button(String.play) {}
                    .buttonStyle(.primary(icon: SFSymbol.play))

                Button(isInMyList ? String.added : .tabMyList) {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation { isInMyList.toggle() }
                }
                .buttonStyle(.glass(icon: isInMyList ? SFSymbol.checkmark : SFSymbol.plus))
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .background(Color.appBackground)
        }
    }
}
