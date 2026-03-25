import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @Binding var isPresented: Bool
    @FocusState private var isSearchFocused: Bool

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(isPresented: Binding<Bool>, seriesRepository: any SeriesRepositoryProtocol) {
        _isPresented = isPresented
        _viewModel = State(initialValue: SearchViewModel(seriesRepository: seriesRepository))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                searchField
                cancelButton
            }
            .padding(.horizontal, 20)
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
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            viewModel.toggleGenre(genre)
                        }
                    } label: {
                        Text(genre)
                            .font(.caption)
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
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Search Results

    private var searchResults: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(viewModel.filteredSeries) { series in
                NavigationLink(value: series) {
                    SeriesImageView(slug: series.slug, type: .coverComplete)
                        .aspectRatio(2/3, contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Trending

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String.trending)
                .font(.title1)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.trendingSeries) { series in
                    NavigationLink(value: series) {
                        SeriesImageView(slug: series.slug, type: .coverComplete)
                            .aspectRatio(2/3, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - No Results

    private var noResults: some View {
        VStack(spacing: 16) {
            Image(systemName: SFSymbol.search)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(String.searchNoResults(viewModel.searchText))
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}
