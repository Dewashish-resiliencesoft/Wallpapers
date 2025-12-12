import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/Functions/set_wallpaper.dart';
import 'package:wallpapers/blocs/wallpaper_set_state.dart';

class WallpaperSetCubit extends Cubit<WallpaperSetState> {
  WallpaperSetCubit() : super(const WallpaperSetState());

  Future<void> setWallpaper(String imageUrl, WallpaperLocation location) async {
    emit(
      state.copyWith(
        status: WallpaperSetStatus.loading,
        activeLocation: location,
      ),
    );

    try {
      final success = await SetWallpaperService.setWallpaper(
        imageUrl,
        location,
      );

      if (success) {
        emit(
          state.copyWith(
            status: WallpaperSetStatus.success,
            clearActiveLocation: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: WallpaperSetStatus.error,
            errorMessage: 'Failed to set wallpaper',
            clearActiveLocation: true,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: WallpaperSetStatus.error,
          errorMessage: e.toString(),
          clearActiveLocation: true,
        ),
      );
    }
  }

  void reset() {
    emit(const WallpaperSetState());
  }
}
