import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

enum WallpaperLocation { homeScreen, lockScreen, both }

class SetWallpaperService {
  /// Downloads the image from URL and caches it
  static Future<File?> _downloadImage(String imageUrl) async {
    try {
      final file = await DefaultCacheManager().getSingleFile(imageUrl);
      return file;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  /// Sets wallpaper on home screen
  static Future<bool> setHomeScreenWallpaper(String imageUrl) async {
    try {
      final file = await _downloadImage(imageUrl);
      if (file == null) return false;

      await WallpaperManagerPlus().setWallpaper(
        file,
        WallpaperManagerPlus.homeScreen,
      );

      return true;
    } catch (e) {
      debugPrint('Error setting home screen wallpaper: $e');
      return false;
    }
  }

  /// Sets wallpaper on lock screen
  static Future<bool> setLockScreenWallpaper(String imageUrl) async {
    try {
      final file = await _downloadImage(imageUrl);
      if (file == null) return false;

      await WallpaperManagerPlus().setWallpaper(
        file,
        WallpaperManagerPlus.lockScreen,
      );

      return true;
    } catch (e) {
      debugPrint('Error setting lock screen wallpaper: $e');
      return false;
    }
  }

  /// Sets wallpaper on both home and lock screens
  static Future<bool> setBothScreensWallpaper(String imageUrl) async {
    try {
      final file = await _downloadImage(imageUrl);
      if (file == null) return false;

      await WallpaperManagerPlus().setWallpaper(
        file,
        WallpaperManagerPlus.bothScreens,
      );

      return true;
    } catch (e) {
      debugPrint('Error setting both screens wallpaper: $e');
      return false;
    }
  }

  /// Main method to set wallpaper based on location
  static Future<bool> setWallpaper(
    String imageUrl,
    WallpaperLocation location,
  ) async {
    switch (location) {
      case WallpaperLocation.homeScreen:
        return await setHomeScreenWallpaper(imageUrl);
      case WallpaperLocation.lockScreen:
        return await setLockScreenWallpaper(imageUrl);
      case WallpaperLocation.both:
        return await setBothScreensWallpaper(imageUrl);
    }
  }
}
