import SwiftUI

struct SeasonPickerView: View {
    let seasons: [Int]
    @Binding var selectedSeason: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(seasons, id: \.self) { season in
                    seasonTab(season)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func seasonTab(_ season: Int) -> some View {
        Button {
            withAnimation(Motion.quickFade) {
                selectedSeason = season
            }
        } label: {
            VStack(spacing: 6) {
                Text(String.season(season))
                    .font(selectedSeason == season ? .bodyMedium : .bodyRegular)
                    .foregroundStyle(selectedSeason == season ? .white : .textSecondary)

                Rectangle()
                    .fill(selectedSeason == season ? Color.accentPink : .clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }
}
