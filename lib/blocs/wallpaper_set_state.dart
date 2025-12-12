import 'package:equatable/equatable.dart';
import 'package:wallpapers/Functions/set_wallpaper.dart';

enum WallpaperSetStatus { initial, loading, success, error }

class WallpaperSetState extends Equatable {
  final WallpaperSetStatus status;
  final String? errorMessage;
  final WallpaperLocation? activeLocation;

  const WallpaperSetState({
    this.status = WallpaperSetStatus.initial,
    this.errorMessage,
    this.activeLocation,
  });

  WallpaperSetState copyWith({
    WallpaperSetStatus? status,
    String? errorMessage,
    WallpaperLocation? activeLocation,
    bool clearActiveLocation = false,
  }) {
    return WallpaperSetState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      activeLocation: clearActiveLocation
          ? null
          : (activeLocation ?? this.activeLocation),
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, activeLocation];
}
