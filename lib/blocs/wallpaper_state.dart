abstract class WallpaperState {}

class WallpaperInitial extends WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  final List<dynamic> images;
  final List<Map<String, String>> categories;
  WallpaperLoaded(this.images, this.categories);
}

class WallpaperError extends WallpaperState {
  final String message;
  WallpaperError(this.message);
}
