import SwiftUI

struct EpisodeGridView: View {
    @State private var selectedEpisode: Int? = nil
    @State private var lockedEpisode: Episode?

    let episodes: [Episode]
    let seriesSlug: String
    var freeCount: Int = 4

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 10),
        count: 5
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            trailerCell

            ForEach(episodes) { episode in
                let isUnlocked = episode.id <= freeCount
                let isNextToUnlock = episode.id == freeCount + 1 || episode.id == freeCount + 2
                let isSelected = selectedEpisode == episode.id

                episodeCell(
                    episode,
                    unlocked: isUnlocked,
                    nextToUnlock: isNextToUnlock,
                    selected: isSelected
                )
                .onTapGesture {
                    if isUnlocked {
                        withAnimation(Motion.selection) {
                            selectedEpisode = episode.id
                        }
                    } else {
                        lockedEpisode = episode
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            if selectedEpisode == nil, let first = episodes.first {
                selectedEpisode = first.id
            }
        }
        .sheet(item: $lockedEpisode) { episode in
            UnlockEpisodeSheet(
                episode: episode,
                seriesSlug: seriesSlug,
                totalLocked: episodes.count - freeCount
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
            .interactiveDismissDisabled(false)
        }
    }

    // MARK: - Trailer Cell

    private var trailerCell: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.08))

            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.white.opacity(0.1), lineWidth: 1)

            Text(String.trailer)
                .font(.bodyMedium)
                .foregroundStyle(.white)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    // MARK: - Episode Cell

    private func episodeCell(
        _ episode: Episode,
        unlocked: Bool,
        nextToUnlock: Bool,
        selected: Bool
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(selected ? Color.accentPink.opacity(0.5) : Color.white.opacity(0.08))

            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    selected ? Color.accentPink : .white.opacity(0.1),
                    lineWidth: selected ? 1.5 : 1
                )

            Text("\(episode.id)")
                .font(.title1)
                .foregroundStyle(unlocked ? .white : .white.opacity(0.4))
        }
        .aspectRatio(1, contentMode: .fit)
        .overlay(alignment: .topTrailing) {
            if !unlocked {
                lockBadge(pink: nextToUnlock)
            }
        }
        .opacity(unlocked || nextToUnlock ? 1 : 0.7)
    }

    // MARK: - Lock Badge

    private func lockBadge(pink: Bool) -> some View {
        Image(systemName: SFSymbol.lock)
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 18, height: 18)
            .background(pink ? Color.accentPink : Color.white.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .offset(x: 4, y: -4)
    }
}
