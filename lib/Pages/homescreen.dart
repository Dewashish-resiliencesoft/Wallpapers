import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/blocs/app_bar_cubit.dart';
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
    return BlocProvider(
      create: (context) => AppBarCubit(),
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
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
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
                    const SizedBox(width: 20),
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
                  child: Column(
                    children: [
                      // Carousel Slider
                      CarouselSlider(
                        options: CarouselOptions(
                          height: size.height * 0.25,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                        ),
                        items: [1, 2, 3, 4, 5].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: size.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://picsum.photos/400/200",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      // Categories Header
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
                      // Categories Grid
                      // Reduced Width Factor from 0.22 to 0.20 to increase gaps
                      SizedBox(
                        height: size.width * 0.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: size.width * 0.22,
                                  width: size.width * 0.20,
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        "https://picsum.photos/100/100",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.width * 0.22,
                                  width: size.width * 0.20,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                customText.semiboldText(
                                  text: "Cat $index",
                                  color: AppTheme.primaryColor,
                                  size: 14,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
            );
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            return ListTile(title: Text('Item #$index'));
          }, childCount: 20),
        ),
      ],
    );
  }
}
