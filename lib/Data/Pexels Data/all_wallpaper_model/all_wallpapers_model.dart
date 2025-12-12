class AllWallpapersModel {
  final List<dynamic> wallpapers;
  final bool isLoading;
  final bool isLoadingMore;
  final String? selectedCategory;
  final String searchQuery;
  final int currentPage;

  const AllWallpapersModel({
    this.wallpapers = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.selectedCategory,
    this.searchQuery = '',
    this.currentPage = 1,
  });

  AllWallpapersModel copyWith({
    List<dynamic>? wallpapers,
    bool? isLoading,
    bool? isLoadingMore,
    String? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
    int? currentPage,
  }) {
    return AllWallpapersModel(
      wallpapers: wallpapers ?? this.wallpapers,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
