import SwiftUI

// MARK: - Placeholder screen to populate the tab: reward data, balance and icons are hardcoded; user-facing copy is localized.

struct RewardsView: View {
    private var dailyRewards: [DailyReward] {
        [
            DailyReward(day: 1, coins: 10, claimed: true),
            DailyReward(day: 2, coins: 10, claimed: false),
            DailyReward(day: 3, coins: 20, claimed: false),
            DailyReward(day: 4, coins: 20, claimed: false),
            DailyReward(day: 5, coins: 25, claimed: false),
            DailyReward(day: 6, coins: 30, claimed: false),
            DailyReward(day: 7, coins: 40, claimed: false),
        ]
    }


    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Color.clear.frame(height: 56)

                    topBar

                    dailyCheckInCard

                    promoBanner

                    followUsSection

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, Layout.screenPadding)
            }

            headerOverlay
        }
        .navigationBarHidden(true)
    }

    private var headerOverlay: some View {
        HStack {
            Text(String.tabRewards)
                .font(.heading)
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal, Layout.screenPadding)
        .padding(.top, 4)
        .padding(.bottom, 8)
        .background(
            LinearGradient(
                colors: [Color.appBackground, Color.appBackground.opacity(0.8), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
        )
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            // Info button
            Image(systemName: "info.circle")
                .font(.system(size: 22))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 44, height: 44)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))

            Spacer()

            // Discount badge
            Text(String.rewardsDiscountBadge)
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.accentPink.opacity(0.8), in: RoundedRectangle(cornerRadius: 12))

            Spacer()

            // Coin balance
            HStack(spacing: 6) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.yellow)
                Text("60")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Daily Check-in

    private var dailyCheckInCard: some View {
        VStack(spacing: 16) {
            // Coin icon
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.yellow)
                .shadow(color: .yellow.opacity(0.3), radius: 12)

            Text(String.rewardsDailyCheckIn)
                .font(.title1)
                .foregroundStyle(.white)

            // Days row
            HStack(spacing: 0) {
                ForEach(dailyRewards, id: \.day) { reward in
                    dayColumn(reward)
                        .frame(maxWidth: .infinity)
                }
            }

            // Extra coins button
            Button {} label: {
                HStack(spacing: 8) {
                    Image(systemName: "video.fill")
                        .font(.system(size: 16))
                    Text(String.rewardsExtraCoins)
                        .font(.button)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [Color.accentPink, Color.accentPink.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 25)
                )
            }
        }
        .padding(20)
        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.white.opacity(0.1), lineWidth: 0.5)
        )
    }

    @ViewBuilder
    private func dayColumn(_ reward: DailyReward) -> some View {
        VStack(spacing: 6) {
            Text(String.rewardsDay(reward.day))
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(reward.claimed ? .white.opacity(0.5) : .white)

            if reward.claimed {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white.opacity(0.4))
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.yellow)
                    .frame(width: 36, height: 36)
            }

            Text(String.rewardsCoins(reward.coins))
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(reward.claimed ? .white.opacity(0.4) : .yellow)
        }
    }

    // MARK: - Promo Banner

    private var promoBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String.rewardsPromoTitle)
                .font(.bodyMedium)
                .foregroundStyle(.white)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(String.rewardsPromoPrice)
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundStyle(.white)

                Text(String.rewardsPromoOriginalPrice)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.4))
                    .strikethrough(color: .white.opacity(0.4))
            }

            Button {} label: {
                HStack(spacing: 4) {
                    Text(String.rewardsPromoClaim)
                        .font(.system(size: 14, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.yellow.opacity(0.9), in: Capsule())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.appBackground.opacity(0.9), .brown.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.yellow.opacity(0.3), lineWidth: 0.5)
        )
    }

    private var followUsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String.rewardsFollowUs)
                .font(.title1)
                .foregroundStyle(.white)

            socialRow(icon: "link", platform: "Facebook", coins: 20)

            Divider().overlay(.white.opacity(0.1))

            socialRow(icon: "link", platform: "TikTok", coins: 20)

            Divider().overlay(.white.opacity(0.1))

            socialRow(icon: "link", platform: "Instagram", coins: 20)

            Divider().overlay(.white.opacity(0.1))

            socialRow(icon: "link", platform: "YouTube", coins: 20)
        }
    }

    @ViewBuilder
    private func socialRow(icon: String, platform: String, coins: Int) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(.white.opacity(0.08), in: Circle())

            HStack(spacing: 4) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.yellow)
                Text(String.rewardsCoins(coins))
                    .font(.bodyMedium)
                    .foregroundStyle(.white)
            }

            Spacer()

            Button {} label: {
                Text(String.rewardsGo)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 70, height: 34)
                    .background(Color.accentPink, in: Capsule())
            }
        }
    }
}

private struct DailyReward {
    let day: Int
    let coins: Int
    let claimed: Bool
}
