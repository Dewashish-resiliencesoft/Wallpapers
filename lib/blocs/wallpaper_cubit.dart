import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/Data/Pexels%20Data/function/wallpaperfetch.dart';
import 'package:wallpapers/blocs/wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  final Datafetch _datafetch = Datafetch();

  WallpaperCubit() : super(WallpaperInitial());

  Future<void> getWallpapers() async {
    try {
      emit(WallpaperLoading());
      await _datafetch.fetchapi();

      // Fetch dynamic categories
      List<String> categoryNames = [
        'Nature',
        'Abstract',
        'Cars',
        'Space',
        'Minimal',
        'Technology',
      ];
      List<Map<String, String>> categories = [];

      await Future.forEach(categoryNames, (name) async {
        String? img = await _datafetch.getCategoryThumbnail(name);
        if (img != null) {
          categories.add({'name': name, 'img': img});
        }
      });

      if (_datafetch.images.isNotEmpty) {
        emit(WallpaperLoaded(_datafetch.images, categories));
      } else {
        emit(WallpaperError("No images found"));
      }
    } catch (e) {
      emit(WallpaperError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is WallpaperLoaded) {
      try {
        await _datafetch.loadmore();
        emit(
          WallpaperLoaded(
            List.from(_datafetch.images),
            currentState.categories,
          ),
        );
      } catch (e) {
        // Optionally emit error or just keep current state
      }
    }
  }
}
