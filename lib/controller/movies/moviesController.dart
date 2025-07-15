import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class moviesController extends GetxController {
  var movies = [].obs;
  var isLoading = true.obs;
  var categorizedMovies = <String, List<dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('http://10.0.2.2/BookFlix/film.php'));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        movies.value = jsonData['data']['films'];

        // Group by category
        final Map<String, List<dynamic>> grouped = {};
        for (var movie in movies) {
          final category = movie['category'] ?? 'Uncategorized';
          if (!grouped.containsKey(category)) {
            grouped[category] = [];
          }
          grouped[category]!.add(movie);
        }

        categorizedMovies.value = grouped;
      } else {
        Get.snackbar("Error", "Failed to load movies");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }

    movies.sort((a, b) => b['likes'].compareTo(a['likes']));
  }
}
