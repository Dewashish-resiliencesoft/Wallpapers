import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpapers/blocs/app_bar_cubit.dart';
import 'package:wallpapers/blocs/wallpaper_cubit.dart';
import 'package:wallpapers/blocs/wallpaper_state.dart';
import 'package:wallpapers/utils/apptexts.dart';
import 'package:wallpapers/utils/apptheme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBarCubit()),
        BlocProvider(create: (context) => WallpaperCubit()..getWallpapers()),
      ],
      child: const Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: _HomeScreenView(),
      ),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  late ScrollController _scrollController;
  final CustomText customText = CustomText();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final size = MediaQuery.of(context).size;
    final expandedHeight = size.height * 0.65;
    final collapsedHeight = 100.0;

    bool isCollapsed =
        _scrollController.hasClients &&
        _scrollController.offset > (expandedHeight - collapsedHeight);
    context.read<AppBarCubit>().setCollapsed(isCollapsed);

    if (_scrollController.hasClients &&
        _scrollController.position.extentAfter < 200) {
      context.read<WallpaperCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: _customsliverappbar(context),
    );
  }

  CustomScrollView _customsliverappbar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        BlocBuilder<AppBarCubit, bool>(
          builder: (context, isCollapsed) {
            final iconColor = isCollapsed
                ? AppTheme.primaryColor
                : AppTheme.secondaryColor;
            final textColor = isCollapsed
                ? AppTheme.primaryColor
                : AppTheme.secondaryColor;

            return SliverAppBar(
              expandedHeight: size.height * 0.65,
              collapsedHeight: 100,
              toolbarHeight: 70,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: isCollapsed
                  ? AppTheme.secondaryColor
                  : AppTheme.primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(top: 25, left: isCollapsed ? 0 : 10),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 45,
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: iconColor.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.poppins(color: textColor),
                                decoration: InputDecoration(
                                  hintText: "Search Wallpapers",
                                  hintStyle: GoogleFonts.poppins(
                                    color: textColor.withValues(alpha: 0.7),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.person, color: iconColor),
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  margin: const EdgeInsets.only(top: 100),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppTheme.primaryColor),
                  child: BlocBuilder<WallpaperCubit, WallpaperState>(
                    builder: (context, state) {
                      if (state is WallpaperLoaded) {
                        final carouselImages = state.images.take(5).toList();

                        final categoryImages = state.categories;

                        return Column(
                          children: [
                            if (carouselImages.isNotEmpty)
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: size.height * 0.25,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1,
                                ),
                                items: carouselImages.map((image) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width: size.width,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: image['src']['large2x'],
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customText.semiboldText(
                                  text: "Categories",
                                  color: AppTheme.secondaryColor,
                                  size: 20,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: customText.lightText(
                                    text: "View All",
                                    color: AppTheme.tertiaryColor,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (categoryImages.isNotEmpty)
                              SizedBox(
                                height: size.width * 0.25,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(categoryImages.length, (
                                    index,
                                  ) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: size.width * 0.22,
                                          width: size.width * 0.20,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  categoryImages[index]['img']!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Container(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: size.width * 0.22,
                                          width: size.width * 0.20,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        customText.lightText(
                                          text: categoryImages[index]['name']!,
                                          color: AppTheme.primaryColor,
                                          size: 14,
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                          ],
                        );
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            children: [
                              Container(
                                height: size.height * 0.25,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 20),
                              Container(height: 50, color: Colors.white),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              centerTitle: true,
            );
          },
        ),
        BlocBuilder<WallpaperCubit, WallpaperState>(
          builder: (context, state) {
            if (state is WallpaperLoading) {
              return SliverToBoxAdapter(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 204 / 362,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) =>
                        Container(color: Colors.white),
                  ),
                ),
              );
            } else if (state is WallpaperError) {
              return SliverFillRemaining(
                child: Center(child: Text(state.message)),
              );
            } else if (state is WallpaperLoaded) {
              final gridImages = state.images.length > 9
                  ? state.images.skip(9).toList()
                  : [];

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childCount: gridImages.length,
                  itemBuilder: (context, index) {
                    final double topPadding = index == 1 ? 50.0 : 0.0;

                    return Padding(
                      padding: EdgeInsets.only(top: topPadding),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 204 / 362,
                              child: CachedNetworkImage(
                                imageUrl: gridImages[index]['src']['tiny'],
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
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              child: const Icon(
                                Icons.favorite_border_outlined,
                                color: AppTheme.primaryColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }
}
