import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/blocs/wallpaper_set_cubit.dart';
import 'package:wallpapers/blocs/wallpaper_set_state.dart';
import 'package:wallpapers/Functions/set_wallpaper.dart';
import 'package:wallpapers/utils/apptheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleWallpaperScreen extends StatefulWidget {
  final String largeUrl;
  final String mediumUrl;

  const SingleWallpaperScreen({
    super.key,
    required this.largeUrl,
    required this.mediumUrl,
  });

  static Route<Object?> routeBuilder(BuildContext context, Object? args) {
    final map = args as Map?;
    final large = map != null ? map['large'] as String? : null;
    final medium = map != null ? map['medium'] as String? : null;
    return MaterialPageRoute(
      builder: (_) =>
          SingleWallpaperScreen(largeUrl: large ?? '', mediumUrl: medium ?? ''),
    );
  }

  @override
  State<SingleWallpaperScreen> createState() => _SingleWallpaperScreenState();
}

class _SingleWallpaperScreenState extends State<SingleWallpaperScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _saveLastOpened();
  }

  Future<void> _saveLastOpened() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_large', widget.largeUrl);
      await prefs.setString('last_medium', widget.mediumUrl);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.largeUrl;
    final blurImageUrl = widget.mediumUrl;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred Background
          CachedNetworkImage(
            imageUrl: blurImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: AppTheme.primaryColor),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Main Image
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 40,
                    top: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Share Button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildActionButton(
                              icon: Icons.share_outlined,
                              onTap: () {
                                // TODO: Implement share functionality
                              },
                            ),
                          ),

                          // Set Button (Center - Larger, Higher)
                          _buildActionButton(
                            iconAsset: 'assets/icons_animated/paint-roller.png',
                            onTap: () {
                              _showSetWallpaperOptions(context);
                            },
                            isCenter: true,
                          ),

                          // Favorite Button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildActionButton(
                              icon: _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              onTap: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Labels Capsules (Separate)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Share Capsule
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Share',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // SET Capsule
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SET',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Favorite Capsule
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Favorite',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSetWallpaperOptions(BuildContext context) {
    final imageUrl = widget.largeUrl;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocProvider(
          create: (context) => WallpaperSetCubit(),
          child: BlocConsumer<WallpaperSetCubit, WallpaperSetState>(
            listener: (context, state) {
              if (state.status == WallpaperSetStatus.success) {
                Navigator.of(modalContext).pop();
                ScaffoldMessenger.of(modalContext).showSnackBar(
                  SnackBar(
                    content: Text('Wallpaper set successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state.status == WallpaperSetStatus.error) {
                ScaffoldMessenger.of(modalContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'Failed to set wallpaper',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      'What would you like to do?',
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options
                    _buildOption(
                      context,
                      'Set on Homescreen',
                      Icons.home_outlined,
                      () {
                        context.read<WallpaperSetCubit>().setWallpaper(
                          imageUrl,
                          WallpaperLocation.homeScreen,
                        );
                      },
                      state.status == WallpaperSetStatus.loading &&
                          state.activeLocation == WallpaperLocation.homeScreen,
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      context,
                      'Set on Lockscreen',
                      Icons.lock_outline,

                      () {
                        context.read<WallpaperSetCubit>().setWallpaper(
                          imageUrl,
                          WallpaperLocation.lockScreen,
                        );
                      },
                      state.status == WallpaperSetStatus.loading &&
                          state.activeLocation == WallpaperLocation.lockScreen,
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      context,
                      'Set on Both',
                      Icons.phonelink_setup_outlined,
                      () {
                        context.read<WallpaperSetCubit>().setWallpaper(
                          imageUrl,
                          WallpaperLocation.both,
                        );
                      },
                      state.status == WallpaperSetStatus.loading &&
                          state.activeLocation == WallpaperLocation.both,
                    ),
                    const SizedBox(height: 24),

                    // Cancel Button
                    ElevatedButton(
                      onPressed: state.status == WallpaperSetStatus.loading
                          ? null
                          : () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    bool isLoading,
  ) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.tertiaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppTheme.secondaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.secondaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.secondaryColor,
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryColor.withValues(alpha: 0.5),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    IconData? icon,
    String? iconAsset,
    required VoidCallback onTap,
    bool isCenter = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isCenter ? 18 : 14),
            decoration: BoxDecoration(
              color: isCenter
                  ? Colors.white
                  : AppTheme.secondaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: isCenter
                  ? null
                  : Border.all(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
            ),
            child: iconAsset != null
                ? Image.asset(
                    iconAsset,
                    width: isCenter ? 28 : 22,
                    height: isCenter ? 28 : 22,
                    color: isCenter ? AppTheme.secondaryColor : Colors.white,
                  )
                : Icon(
                    icon!,
                    color: isCenter ? AppTheme.secondaryColor : Colors.white,
                    size: isCenter ? 28 : 22,
                  ),
          ),
        ],
      ),
    );
  }
}
