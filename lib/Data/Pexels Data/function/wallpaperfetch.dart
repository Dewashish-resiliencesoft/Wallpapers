import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:http/http.dart' as http;
import 'package:wallpapers/Data/Pexels%20Data/pexelsapi.dart';

class Datafetch {
  var images = <dynamic>[];
  int page = 1;
  int perPage = 50;
  bool isloading = false;

  Future<void> fetchapi() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.pexels.com/v1/curated?per_page=$perPage&page=$page',
        ),
        headers: {'Authorization': PexelsApi.authorizationkey.toString()},
      );

      log("Status code: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        images.addAll(result['photos']);
      } else {
        log("API fetch failed. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("API fetch error: $e");
    }
  }

  Future<void> loadmore() async {
    if (isloading) return;

    isloading = true;
    page++;
    String url =
        'https://api.pexels.com/v1/curated?per_page=$perPage&page=$page';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': PexelsApi.authorizationkey.toString()},
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        isloading = false;
        Map result = jsonDecode(response.body);
        images.addAll(result['photos']);
      }
    } catch (e) {
      isloading = false;
      log("api load more error $e");
    }
  }

  Future<String?> getCategoryThumbnail(String query) async {
    int randomPage = Random().nextInt(100) + 1;
    String url =
        'https://api.pexels.com/v1/search?query=$query&per_page=1&page=$randomPage';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': PexelsApi.authorizationkey.toString()},
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        if (result['photos'].isNotEmpty) {
          return result['photos'][0]['src']['large'];
        }
      }
    } catch (e) {
      log("Error fetching category thumbnail for $query: $e");
    }
    return null;
  }
}
