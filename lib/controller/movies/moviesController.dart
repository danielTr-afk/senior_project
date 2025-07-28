import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class moviesController extends GetxController {
  var movies = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var categorizedMovies = <String, List<Map<String, dynamic>>>{}.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      isLoading(true);
      errorMessage('');

      var response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/film.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          // Safely extract movies list
          var moviesData = jsonData['data']['films'];
          if (moviesData != null && moviesData is List) {
            movies.value = List<Map<String, dynamic>>.from(
                moviesData.map((movie) => Map<String, dynamic>.from(movie ?? {}))
            );

            // Sort by likes (handle null values)
            movies.sort((a, b) {
              var likesA = int.tryParse(a['likes']?.toString() ?? '0') ?? 0;
              var likesB = int.tryParse(b['likes']?.toString() ?? '0') ?? 0;
              return likesB.compareTo(likesA);
            });

            // Group by category
            _categorizeMovies();
          } else {
            movies.clear();
            errorMessage('No movies data found');
          }
        } else {
          errorMessage(jsonData['message'] ?? 'Failed to load movies');
        }
      } else {
        errorMessage("Server error: ${response.statusCode}");
        Get.snackbar("Error", "Failed to load movies. Status: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage("Network error: ${e.toString()}");
      Get.snackbar("Error", "Network error: ${e.toString()}");
      print('Error fetching movies: $e');
    } finally {
      isLoading(false);
    }
  }

  void _categorizeMovies() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var movie in movies) {
      final category = movie['category']?.toString() ?? 'Uncategorized';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(movie);
    }

    categorizedMovies.value = grouped;
  }

  // Method to refresh movies
  Future<void> refreshMovies() async {
    await fetchMovies();
  }

  // Method to get movies by category
  List<Map<String, dynamic>> getMoviesByCategory(String category) {
    return categorizedMovies[category] ?? [];
  }

  // Method to search movies
  List<Map<String, dynamic>> searchMovies(String query) {
    if (query.isEmpty) return movies;

    return movies.where((movie) {
      final title = movie['title']?.toString().toLowerCase() ?? '';
      final description = movie['description']?.toString().toLowerCase() ?? '';
      final category = movie['category']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return title.contains(searchQuery) ||
          description.contains(searchQuery) ||
          category.contains(searchQuery);
    }).toList();
  }
}