import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @Binding var isPresented: Bool
    @FocusState private var isSearchFocused: Bool
    @Binding var path: [Series]

    private let myListRepository: any MyListRepositoryProtocol

    private let columns = Layout.posterColumns

    init(isPresented: Binding<Bool>,
         path: Binding<[Series]>,
         seriesRepository: any SeriesRepositoryProtocol,
         myListRepository: any MyListRepositoryProtocol) {
        _isPresented = isPresented
        _path = path
        self.myListRepository = myListRepository
        _viewModel = State(initialValue: SearchViewModel(seriesRepository: seriesRepository))
    }

    var body: some View {
        // The overlay sits outside the tab NavigationStacks, so it needs its own stack
        // (and destination) for the result links to navigate.
        NavigationStack(path: $path) {
            searchContent
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(for: Series.self) { series in
                    SeriesDetailView(series: series, myListRepository: myListRepository)
                }
        }
    }

    private var searchContent: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                searchField
                cancelButton
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.top, 16)

            Rectangle()
                .fill(.white.opacity(0.06))
                .frame(height: 0.5)
                .padding(.top, 14)

            genreFilters

            ScrollView {
                if !viewModel.hasActiveFilters {
                    trendingSection
                } else if viewModel.filteredSeries.isEmpty {
                    noResults
                } else {
                    searchResults
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
        .onChange(of: isPresented) { _, presented in
            if !presented {
                isSearchFocused = false
            }
        }
    }

    // MARK: - Search Field

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: SFSymbol.search)
                .font(.button)
                .foregroundStyle(.secondary)

            TextField(String.searchPlaceholder, text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .foregroundStyle(.white)
                .tint(.accentPink)
                .focused($isSearchFocused)
                .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: SFSymbol.closeFilled)
                        .font(.button)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Cancel

    private var cancelButton: some View {
        Button {
            isSearchFocused = false
            isPresented = false
        } label: {
            Text(String.cancel)
                .font(.button)
                .foregroundStyle(.accentPink)
        }
    }

    // MARK: - Genre Filters

    private var genreFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.allGenres, id: \.self) { genre in
                    let isSelected = viewModel.selectedGenres.contains(genre)
                    Button {
                        withAnimation(Motion.selection) {
                            viewModel.toggleGenre(genre)
                        }
                    } label: {
                        Text(genre)
                            .font(.captionMedium)
                            .foregroundStyle(isSelected ? .white : .secondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                isSelected
                                    ? AnyShapeStyle(.accentPink)
                                    : AnyShapeStyle(.white.opacity(0.08)),
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Search Results

    private var searchResults: some View {
        LazyVGrid(columns: columns, spacing: Layout.posterGridRowSpacing) {
            ForEach(viewModel.filteredSeries) { series in
                NavigationLink(value: series) {
                    SeriesImageView(slug: series.slug, type: .coverComplete)
                        .aspectRatio(2/3, contentMode: .fill)
                        .cardStyle(bordered: false)
                }
            }
        }
        .padding(.horizontal, Layout.screenPadding)
        .padding(.top, 16)
    }

    // MARK: - Trending

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String.trending)
                .font(.title1)
                .foregroundStyle(.white)
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 16)

            LazyVGrid(columns: columns, spacing: Layout.posterGridRowSpacing) {
                ForEach(viewModel.trendingSeries) { series in
                    NavigationLink(value: series) {
                        SeriesImageView(slug: series.slug, type: .coverComplete)
                            .aspectRatio(2/3, contentMode: .fill)
                            .cardStyle(bordered: false)
                    }
                }
            }
            .padding(.horizontal, Layout.screenPadding)
        }
    }

    // MARK: - No Results

    private var noResults: some View {
        VStack(spacing: 16) {
            Image(systemName: SFSymbol.search)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(String.searchNoResults(viewModel.searchText))
                .font(.bodyRegular)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}
