import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var showViewAll: Bool = false
    var onViewAll: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(.title1)
                .foregroundStyle(.white)

            Spacer()

            if showViewAll {
                Button {
                    onViewAll?()
                } label: {
                    Text(String.viewAll)
                        .font(.small)
                        .foregroundStyle(.textSecondary)
                }
            }
        }
        .padding(.horizontal)
    }
}
