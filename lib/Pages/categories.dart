import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpapers/utils/apptheme.dart';
import 'package:wallpapers/utils/apptexts.dart';

import 'package:wallpapers/Data/Pexels Data/Categories_data/categories_data.dart';
import 'package:wallpapers/Data/Pexels Data/function/wallpaperfetch.dart';
import 'package:wallpapers/Pages/all_wallpapers_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final List<String> _categories;

  @override
  void initState() {
    super.initState();
    _categories = CategoriesData.categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: CustomText().semiboldText(
          text: "Categories",
          size: 20,
          color: AppTheme.secondaryColor,
          weight: FontWeight.w600,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.secondaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final categoryName = _categories[index];
            // Pattern: Large (1.0), Tall (0.7), Wide (1.3)
            final double aspectRatio = (index % 4 == 0)
                ? 1.0
                : (index % 4 == 1)
                ? 0.7
                : 1.25;

            return AspectRatio(
              aspectRatio: aspectRatio,
              child: CategoryTile(categoryName: categoryName),
            );
          },
        ),
      ),
    );
  }
}

class CategoryTile extends StatefulWidget {
  final String categoryName;

  const CategoryTile({super.key, required this.categoryName});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>
    with AutomaticKeepAliveClientMixin {
  String? _imageUrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    final url = await Datafetch().getCategoryThumbnail(widget.categoryName);
    if (mounted) {
      setState(() {
        _imageUrl = url;
        _loading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AllWallpapersPage(category: widget.categoryName),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image or Shimmer
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _loading || _imageUrl == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    )
                  : CachedNetworkImage(
                      imageUrl: _imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Text
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: CustomText().semiboldText(
                text: widget.categoryName.replaceAll(' ', '\n'),
                size: 14,
                color: Colors.white,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
