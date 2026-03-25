import Foundation

extension String {
    // MARK: - Tabs

    static let tabLibrary = NSLocalizedString("tab.library", comment: "")
    static let tabForYou = NSLocalizedString("tab.forYou", comment: "")
    static let tabMyList = NSLocalizedString("tab.myList", comment: "")
    static let tabRewards = NSLocalizedString("tab.rewards", comment: "")
    static let tabSearch = NSLocalizedString("tab.search", comment: "")

    // MARK: - Common Actions

    static let play = NSLocalizedString("action.play", comment: "")
    static let cancel = NSLocalizedString("action.cancel", comment: "")
    static let viewAll = NSLocalizedString("action.viewAll", comment: "")
    static let added = NSLocalizedString("action.added", comment: "")
    static let share = NSLocalizedString("action.share", comment: "")
    static let goBack = NSLocalizedString("action.goBack", comment: "")
    static let more = NSLocalizedString("action.more", comment: "")

    // MARK: - App

    static let appName = NSLocalizedString("app.name", comment: "")

    // MARK: - Home

    static let trending = NSLocalizedString("home.trending", comment: "")
    static let mostTrending = NSLocalizedString("home.mostTrending", comment: "")
    static let onlyOnShorts = NSLocalizedString("home.onlyOnShorts", comment: "")
    static let newOnShorts = NSLocalizedString("home.newOnShorts", comment: "")
    static let topPicks = NSLocalizedString("home.topPicks", comment: "")
    static let comingSoon = NSLocalizedString("home.comingSoon", comment: "")
    static let continueWatching = NSLocalizedString("home.continueWatching", comment: "")
    static let hot = NSLocalizedString("home.hot", comment: "")

    // MARK: - For You

    static let forYouTitle = NSLocalizedString("forYou.title", comment: "")
    static let forYouSubtitle = NSLocalizedString("forYou.subtitle", comment: "")
    static let forYouPicked = NSLocalizedString("forYou.picked", comment: "")
    static let forYouBecause = NSLocalizedString("forYou.because", comment: "")

    static func episodeProgress(_ current: Int, _ total: Int) -> String {
        String(format: NSLocalizedString("home.episodeProgress", comment: ""), current, total)
    }

    // MARK: - My List

    static let myListTitle = NSLocalizedString("myList.title", comment: "")
    static let myListEmptyTitle = NSLocalizedString("myList.empty.title", comment: "")
    static let myListEmptySubtitle = NSLocalizedString("myList.empty.subtitle", comment: "")

    // MARK: - Search

    static let searchPlaceholder = NSLocalizedString("search.placeholder", comment: "")
    static func searchNoResults(_ query: String) -> String {
        String(format: NSLocalizedString("search.noResults", comment: ""), query)
    }

    // MARK: - Series Detail

    static func episodes(_ count: Int) -> String {
        String(format: NSLocalizedString("detail.episodes", comment: ""), count)
    }
    static func season(_ number: Int) -> String {
        String(format: NSLocalizedString("detail.season", comment: ""), number)
    }
    static let trailer = NSLocalizedString("detail.trailer", comment: "")

    static func shareText(_ title: String) -> String {
        String(format: NSLocalizedString("detail.share", comment: ""), title)
    }

    static func starring(_ names: String) -> String {
        String(format: NSLocalizedString("detail.starring", comment: ""), names)
    }

    // MARK: - Unlock Sheet

    static let unlockTitle = NSLocalizedString("unlock.title", comment: "")
    static let trendingNow = NSLocalizedString("unlock.trendingNow", comment: "")
    static let lovedIt = NSLocalizedString("unlock.lovedIt", comment: "")
    static func unlockSubtitle(_ episode: Int) -> String {
        String(format: NSLocalizedString("unlock.subtitle", comment: ""), episode)
    }
    static func unlockEpisodeLabel(_ episode: Int) -> String {
        String(format: NSLocalizedString("unlock.episode", comment: ""), episode)
    }
    static func unlockEpisode(_ episode: Int) -> String {
        String(format: NSLocalizedString("unlock.unlockEpisode", comment: ""), episode)
    }
    static let unlockAll = NSLocalizedString("unlock.unlockAll", comment: "")
    static func unlockBingeStory(_ count: Int) -> String {
        String(format: NSLocalizedString("unlock.bingeStory", comment: ""), count)
    }
    static let bestValue = NSLocalizedString("unlock.bestValue", comment: "")
    static let priceAll = NSLocalizedString("unlock.priceAll", comment: "")
    static let pricePerEp = NSLocalizedString("unlock.pricePerEp", comment: "")
    static let priceSingle = NSLocalizedString("unlock.priceSingle", comment: "")
    static let limitedOffer = NSLocalizedString("unlock.limitedOffer", comment: "")
    static let restorePurchases = NSLocalizedString("unlock.restore", comment: "")

    // MARK: - Toast

    static func toastAdded(_ title: String) -> String {
        String(format: NSLocalizedString("toast.added", comment: ""), title)
    }
    static func toastRemoved(_ title: String) -> String {
        String(format: NSLocalizedString("toast.removed", comment: ""), title)
    }

    // MARK: - Top Picks

    static func episodesCount(_ count: Int) -> String {
        String(format: NSLocalizedString("topPicks.episodes", comment: ""), count)
    }
}
