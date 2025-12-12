import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpapers/Data/Pexels Data/Categories_data/categories_data.dart';
import 'package:wallpapers/blocs/all_wallpapers_cubit.dart';
import 'package:wallpapers/Data/Pexels%20Data/all_wallpaper_model/all_wallpapers_model.dart';
import 'package:wallpapers/Pages/singlewallpaperscreen.dart';
import 'package:wallpapers/utils/apptheme.dart';
import 'package:wallpapers/utils/apptexts.dart';

class AllWallpapersPage extends StatelessWidget {
  final String? category;

  const AllWallpapersPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AllWallpapersCubit(initialCategory: category)..fetchWallpapers(),
      child: const _AllWallpapersView(),
    );
  }
}

class _AllWallpapersView extends StatefulWidget {
  const _AllWallpapersView();

  @override
  State<_AllWallpapersView> createState() => _AllWallpapersViewState();
}

class _AllWallpapersViewState extends State<_AllWallpapersView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AllWallpapersCubit>().loadMore();
    }
  }

  void _onSearch(String query) {
    context.read<AllWallpapersCubit>().search(query);
  }

  void _applyFilter(String? category) {
    context.read<AllWallpapersCubit>().applyFilter(category);
    _searchController.clear();
    Navigator.pop(context);
  }

  void _showFilterBottomSheet(String? selectedCategory) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText().semiboldText(
                    text: 'Filter by Category',
                    size: 18,
                    color: AppTheme.secondaryColor,
                    weight: FontWeight.w600,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (selectedCategory != null)
                TextButton.icon(
                  onPressed: () => _applyFilter(null),
                  icon: const Icon(Icons.clear, size: 18),
                  label: CustomText().lightText(
                    text: 'Clear Filter',
                    size: 14,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: CategoriesData.categories.length,
                  itemBuilder: (context, index) {
                    final category = CategoriesData.categories[index];
                    final isSelected = selectedCategory == category;
                    return ListTile(
                      title: CustomText().semiboldText(
                        text: category,
                        size: 14,
                        color: isSelected
                            ? AppTheme.secondaryColor
                            : AppTheme.tertiaryColor,
                        weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppTheme.secondaryColor,
                            )
                          : null,
                      onTap: () => _applyFilter(category),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(10),
      itemCount: 10,
      itemBuilder: (context, index) {
        final height = (index % 3 == 0) ? 200.0 : 150.0;
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllWallpapersCubit, AllWallpapersModel>(
      builder: (context, state) {
        final title = state.selectedCategory ?? 'All Wallpapers';

        return Scaffold(
          backgroundColor: AppTheme.primaryColor,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            title: CustomText().semiboldText(
              text: title,
              size: 20,
              color: AppTheme.secondaryColor,
              weight: FontWeight.w600,
            ),
            iconTheme: const IconThemeData(color: AppTheme.secondaryColor),
          ),
          body: Column(
            children: [
              // Search Bar and Filter
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: AppTheme.tertiaryColor.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _onSearch,
                          style: const TextStyle(
                            color: AppTheme.secondaryColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search wallpapers',
                            hintStyle: TextStyle(
                              color: AppTheme.tertiaryColor.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppTheme.tertiaryColor,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: state.selectedCategory != null
                            ? AppTheme.secondaryColor
                            : AppTheme.secondaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppTheme.tertiaryColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_alt,
                          color: state.selectedCategory != null
                              ? AppTheme.primaryColor
                              : AppTheme.secondaryColor,
                        ),
                        onPressed: () =>
                            _showFilterBottomSheet(state.selectedCategory),
                      ),
                    ),
                  ],
                ),
              ),
              // Wallpapers Grid
              Expanded(
                child: state.isLoading && state.wallpapers.isEmpty
                    ? _buildShimmerGrid()
                    : MasonryGridView.count(
                        controller: _scrollController,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.all(10),
                        itemCount:
                            state.wallpapers.length +
                            (state.isLoadingMore ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.wallpapers.length) {
                            // Show shimmer for loading more
                            final height = (index % 3 == 0) ? 200.0 : 150.0;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: height,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            );
                          }

                          final wallpaper = state.wallpapers[index];
                          final imageUrl = wallpaper['src']['large'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleWallpaperScreen(image: wallpaper),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(color: Colors.white),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppTheme.tertiaryColor.withValues(
                                        alpha: 0.5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
