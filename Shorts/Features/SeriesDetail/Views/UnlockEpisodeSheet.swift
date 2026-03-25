//
//  UnlockEpisodeSheet.swift
//  Shorts
//
//  Created by Mehmed Tukulic on 25. 3. 2026..
//

import SwiftUI

struct UnlockEpisodeSheet: View {
    @Environment(\.dismiss) private var dismiss

    let episode: Episode
    let seriesSlug: String
    let totalLocked: Int

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    SeriesImageView(slug: seriesSlug, type: .coverComplete)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 260)
                        .clipped()

                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black.opacity(0.6), location: 0.5),
                            .init(color: .black.opacity(0.95), location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    VStack(spacing: 8) {
                        Image(systemName: SFSymbol.lockCircle)
                            .font(.system(size: 44))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10)

                        Text(String.unlockEpisodeLabel(episode.id))
                            .font(.button)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.bottom, 30)
                }
                .frame(height: 260)

                VStack(spacing: 6) {
                    Text(String.unlockTitle)
                        .font(.title2)
                        .foregroundStyle(.white)

                    Text(String.unlockSubtitle(episode.id))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)

                HStack(spacing: 16) {
                    proofBadge(icon: SFSymbol.flame, text: .trendingNow, color: .orange)
                    proofBadge(icon: SFSymbol.heart, text: .lovedIt, color: .accentPink)
                }
                .padding(.top, 20)

                VStack(spacing: 12) {
                    Button { dismiss() } label: {
                        VStack(spacing: 4) {
                            HStack {
                                Spacer()
                                Text(String.bestValue)
                                    .font(.system(size: 10, weight: .heavy))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.accentPink, in: Capsule())
                                    .offset(y: -6)
                            }
                            .padding(.trailing, 16)

                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(String.unlockAll)
                                        .font(.button)
                                        .foregroundStyle(.white)
                                    Text(String.unlockBingeStory(totalLocked))
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 1) {
                                    Text(String.priceAll)
                                        .font(.system(size: 18, weight: .heavy))
                                        .foregroundStyle(.white)
                                    Text(String.pricePerEp)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.bottom, 14)
                        }
                        .background(
                            LinearGradient(
                                colors: [Color.accentPink, Color.accentPink.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                    }
                    .buttonStyle(.plain)

                    Button { dismiss() } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(String.unlockEpisode(episode.id))
                                    .font(.bodyMedium)
                                    .foregroundStyle(.white)
                                Text(episode.duration)
                                    .font(.small)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(String.priceSingle)
                                .font(.button)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.white.opacity(0.12), in: Capsule())
                        }
                        .padding(16)
                        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                HStack(spacing: 6) {
                    Image(systemName: SFSymbol.clock)
                        .font(.small)
                    Text(String.limitedOffer)
                        .font(.small)
                }
                .foregroundStyle(.accentPink)
                .padding(.top, 16)

                Button { dismiss() } label: {
                    Text(String.restorePurchases)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
    }

    private func proofBadge(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.small)
                .foregroundStyle(color)
            Text(text)
                .font(.small)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.white.opacity(0.06), in: Capsule())
    }
}

