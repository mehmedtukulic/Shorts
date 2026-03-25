# Shorts

A mini streaming app built with SwiftUI as part of the Luni iOS case study. Two core screens (Homepage + Series Detail) with full navigation, plus supporting tabs for My List, For You, Search, and Rewards.

## Architecture

**MVVM** with protocol-based repositories and SwiftUI `@Environment` for dependency injection.

```
App/                    → Entry point, TabView, navigation
Features/
  Home/                 → Homepage with section-based feed
  SeriesDetail/         → Parallax header, episode grid, unlock sheet
  ForYou/               → Personalized recommendations based on watch history
  MyList/               → Saved series with persistence
  Search/               → Full-text search with genre filtering
  Rewards/              → Daily check-in, promo banners (hardcoded UI)
Models/                 → Series, HomepageSection, response DTOs
Repositories/           → SeriesRepository (async), MyListRepository (UserDefaults)
Utilities/              → Image loading, common views, button styles, modifiers
Resources/              → Design tokens, localization, mock data, assets
```

### Data Flow

`MockData.json` mirrors a real API response — sections contain full series objects inline, no client-side ID resolution. The repository decodes off the main thread via `Task.detached` and exposes typed `[HomepageSectionData]`. ViewModels own repositories passed through init (no singleton access). Views receive data through their ViewModel only.

### Key Decisions

- **No singletons** — Repositories are injected via `@Environment` at the app root and passed through view inits to ViewModels
- **`@Observable` on MyListRepository** — Required because SwiftUI views need to react to list mutations (add/remove) across multiple screens
- **SeriesRepository is not `@Observable`** — It's a plain class. Loading state lives in ViewModels where it belongs
- **Native `TabView`** with hidden system tab bar + custom pill-shaped tab bar overlay. Each tab has its own `NavigationStack` so view state is preserved across tab switches
- **Tab bar visibility** managed via an `@Observable` `TabBarVisibility` object in the environment — detail screens hide it on `onAppear`, root screens restore it
- **iOS 26 Liquid Glass** support with `#available` fallbacks to `.ultraThinMaterial`
- **Async image loading** — `SeriesImageLoader` with `NSCache` (100 item limit). In production this would be `AsyncImage` with URL-based caching
- **Full localization** — All user-facing strings go through `Localizable.strings` via `String` extensions

## Technical Requirements

- **SwiftUI** — 100% pure, no UIKit views
- **iOS 17+** minimum deployment target
- **MVVM** throughout — every feature screen has a dedicated ViewModel
- **Async/Await** — Repository loading, simulated network delay, Task.detached for decoding
- **Zero dependencies** — Apple frameworks only

## Screens

| Screen | Description |
|--------|-------------|
| **Homepage** | Hero carousel, continue watching with progress bars, coming soon paged carousel, ranked trending, horizontal rows, top picks |
| **Series Detail** | Parallax header with stretch/fade, expandable description, cast info, season picker, episode grid with lock states, unlock paywall sheet, share button |
| **For You** | Personalized grid based on genre overlap from continue watching + my list |
| **My List** | Persistent saved series grid (UserDefaults), remove with animation |
| **Search** | Real-time text search + genre chip filtering, trending default state |
| **Rewards** | Daily check-in, promo banner, social follow rows (hardcoded) |

## How to Run

1. Open `Shorts.xcodeproj` in Xcode 16+
2. Select an iOS 17+ simulator or device
3. Build and run

## Time Spent

~10 hours over 2 days

## NOTES:
At the beginning of the task I was wondering why are the short covers provided and later realised that the app would look junky if the images didn't have consistent quality/resolutions if i decided to go with some urls I find on web. So I decided to put the whole folder in the app, create a mock.json file that would simulate the "optimal" response I would expect from BE, and did the mapping of the images based on its slug in SeriesImageLoader. In real project those images url's would usually come from BE and I would use async image to load them with some internal caching.
Since this is small test project, I decided to go with the swiftui navigation, to avoid wasting time setuping coordinators which I would usually go for.
Things I would improve:
Dependency injection - it's bad with the current navigation setup, I would do the injections in coordinator or even better use some container based injection
TabBar - From the beginning I created a custom tabbar to support liquid glass on both 17+ and 26+ version, then I had issues with my tab views being recreated on each tab switch, so I used native tabview to keep views in memory, hide it so it works under the hood, and displayed custom tabbar instead. There is probably a better solution to this, so on real project I would spend some more time investigating.
Performance - A lot of things could be improved to optimise peformance on large data sets, with current data it was not necessary, but definitely worth taking some more time on real project.
Resources - I avoided downloading many resources/icons from figma because of my self-restrictions on time, I was trying to match as much as possible with system provided icons
Tests - I thought they were unecessary for this task, but would add them on every project.

I have filled all the tabs and added some additional screens because you wrote: "Have fun and deliver something you'd be proud to showcase on your App Store account." and I can't showcase only 1 working tab on App Store account :D 
