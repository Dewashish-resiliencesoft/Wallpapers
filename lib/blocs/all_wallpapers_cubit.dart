import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/Data/Pexels%20Data/pexelsapi.dart';
import 'package:wallpapers/Data/Pexels%20Data/all_wallpaper_model/all_wallpapers_model.dart';

class AllWallpapersCubit extends Cubit<AllWallpapersModel> {
  AllWallpapersCubit({String? initialCategory})
    : super(AllWallpapersModel(selectedCategory: initialCategory));

  Future<void> fetchWallpapers({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      emit(state.copyWith(isLoading: true, wallpapers: [], currentPage: 1));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    try {
      String url;
      if (state.searchQuery.isNotEmpty) {
        url =
            'https://api.pexels.com/v1/search?query=${state.searchQuery}&per_page=50&page=${state.currentPage}';
      } else if (state.selectedCategory != null) {
        url =
            'https://api.pexels.com/v1/search?query=${state.selectedCategory}&per_page=50&page=${state.currentPage}';
      } else {
        url =
            'https://api.pexels.com/v1/curated?per_page=50&page=${state.currentPage}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': PexelsApi.authorizationkey},
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final result = jsonDecode(response.body);
        final newWallpapers = List<dynamic>.from(state.wallpapers)
          ..addAll(result['photos']);
        emit(state.copyWith(wallpapers: newWallpapers, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore) return;

    emit(
      state.copyWith(isLoadingMore: true, currentPage: state.currentPage + 1),
    );

    await fetchWallpapers();

    emit(state.copyWith(isLoadingMore: false));
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query, clearCategory: true));
    fetchWallpapers(refresh: true);
  }

  void applyFilter(String? category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        clearCategory: category == null,
        searchQuery: '',
      ),
    );
    fetchWallpapers(refresh: true);
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }
}
