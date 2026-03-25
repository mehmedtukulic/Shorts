import SwiftUI

// MARK: - Search Button Position Reporting

struct SearchButtonCenterKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        let next = nextValue()
        if next != .zero { value = next }
    }
}

enum AppTab: Int, CaseIterable {
    case library, forYou, myList, rewards, search

    var title: String {
        switch self {
        case .library: .tabLibrary
        case .forYou: .tabForYou
        case .myList: .tabMyList
        case .rewards: .tabRewards
        case .search: .tabSearch
        }
    }

    var icon: String {
        switch self {
        case .library: SFSymbol.library
        case .forYou: SFSymbol.forYou
        case .myList: SFSymbol.myList
        case .rewards: SFSymbol.rewards
        case .search: SFSymbol.search
        }
    }

    static var pillTabs: [AppTab] {
        [.library, .forYou, .myList, .rewards]
    }
}

struct MainTabBar: View {
    @Binding var selectedTab: AppTab
    @Binding var showSearch: Bool
    @Namespace private var tabAnimation

    var body: some View {
        HStack(spacing: 12) {
            tabPills
            searchButton
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 2)
    }

    // MARK: - Tab Pill

    private var tabPills: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.pillTabs, id: \.rawValue) { tab in
                tabItem(tab)
            }
        }
        .padding(6)
        .modifier(LiquidGlassCapsuleModifier())
    }

    // MARK: - Search Button

    private var searchButton: some View {
        Button {
            showSearch.toggle()
        } label: {
            Image(systemName: SFSymbol.search)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .modifier(LiquidGlassCircleModifier())
        }
        .background {
            GeometryReader { geo in
                Color.clear.preference(
                    key: SearchButtonCenterKey.self,
                    value: CGPoint(
                        x: geo.frame(in: .global).midX,
                        y: geo.frame(in: .global).midY
                    )
                )
            }
        }
    }

    // MARK: - Tab Item

    @ViewBuilder
    private func tabItem(_ tab: AppTab) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 2) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(tab == .rewards ? .accentPink : (selectedTab == tab ? .white : .secondary))
                Text(tab.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(selectedTab == tab ? .white : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .background {
                if selectedTab == tab {
                    Capsule()
                        .fill(.white.opacity(0.15))
                        .matchedGeometryEffect(id: "activeTab", in: tabAnimation)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
