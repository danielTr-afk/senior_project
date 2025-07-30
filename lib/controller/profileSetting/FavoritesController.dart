import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../authController/loginGetX.dart';

class FavoritesController extends GetxController {
  var favoriteBooks = <Map<String, dynamic>>[].obs;
  var favoriteMovies = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'http://10.0.2.2/BookFlix/favorites.php';

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Get current user ID from login controller
  String get currentUserId {
    try {
      // Import your login controller at the top of the file
      // import '../authController/loginGetX.dart';
      final loginController = Get.find<loginGetx>();
      return loginController.userId.value.toString();
    } catch (e) {
      print('Error getting user ID: $e');
      return '32'; // fallback
    }
  }

  // Load all favorites from server
  Future<void> loadFavorites() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse('$baseUrl?action=get_favorites&user_id=$currentUserId&type=all'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          final List<dynamic> favorites = data['data'] ?? [];

          // Separate books and movies
          favoriteBooks.clear();
          favoriteMovies.clear();

          for (var item in favorites) {
            if (item['type'] == 'book') {
              favoriteBooks.add(Map<String, dynamic>.from(item));
            } else if (item['type'] == 'movie') {
              favoriteMovies.add(Map<String, dynamic>.from(item));
            }
          }
        } else {
          print('Error loading favorites: ${data['message']}');
        }
      } else {
        print('HTTP Error loading favorites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      isLoading(false);
    }
  }

  // Check if item is favorite
  Future<bool> isFavorite(String itemId, String itemType) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?action=is_favorite&user_id=$currentUserId&item_id=$itemId&item_type=$itemType'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['is_favorite'] ?? false;
        }
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
    return false;
  }

  // Toggle book favorite
  Future<void> toggleBookFavorite(Map<String, dynamic> book) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'user_id': currentUserId,
          'item_id': book['id'].toString(),
          'item_type': 'book',
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          if (data['action'] == 'added') {
            // Add to local list if not already there
            if (!favoriteBooks.any((b) => b['id'].toString() == book['id'].toString())) {
              var bookWithType = Map<String, dynamic>.from(book);
              bookWithType['type'] = 'book';
              favoriteBooks.add(bookWithType);
            }
          } else {
            // Remove from local list
            favoriteBooks.removeWhere((b) => b['id'].toString() == book['id'].toString());
          }

          Get.snackbar(
            data['action'] == 'added' ? "Added to Favorites" : "Removed from Favorites",
            "${book['title']} ${data['message']}",
            duration: Duration(seconds: 2),
          );
        } else {
          Get.snackbar("Error", data['message'] ?? 'Failed to update favorites');
        }
      } else {
        Get.snackbar("Error", "Failed to update favorites. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error toggling book favorite: $e');
      Get.snackbar("Error", "Network error occurred");
    }
  }

  // Toggle movie favorite
  Future<void> toggleMovieFavorite(Map<String, dynamic> movie) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'user_id': currentUserId,
          'item_id': movie['id'].toString(),
          'item_type': 'movie',
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          if (data['action'] == 'added') {
            // Add to local list if not already there
            if (!favoriteMovies.any((m) => m['id'].toString() == movie['id'].toString())) {
              var movieWithType = Map<String, dynamic>.from(movie);
              movieWithType['type'] = 'movie';
              favoriteMovies.add(movieWithType);
            }
          } else {
            // Remove from local list
            favoriteMovies.removeWhere((m) => m['id'].toString() == movie['id'].toString());
          }

          Get.snackbar(
            data['action'] == 'added' ? "Added to Favorites" : "Removed from Favorites",
            "${movie['title']} ${data['message']}",
            duration: Duration(seconds: 2),
          );
        } else {
          Get.snackbar("Error", data['message'] ?? 'Failed to update favorites');
        }
      } else {
        Get.snackbar("Error", "Failed to update favorites. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error toggling movie favorite: $e');
      Get.snackbar("Error", "Network error occurred");
    }
  }

  // Check if book is favorite (local check for UI updates)
  bool isBookFavorite(String bookId) {
    return favoriteBooks.any((book) => book['id'].toString() == bookId);
  }

  // Check if movie is favorite (local check for UI updates)
  bool isMovieFavorite(String movieId) {
    return favoriteMovies.any((movie) => movie['id'].toString() == movieId);
  }

  // Remove book from favorites
  Future<void> removeBookFromFavorites(String bookId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl?action=remove&user_id=$currentUserId&item_id=$bookId&item_type=book'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          favoriteBooks.removeWhere((book) => book['id'].toString() == bookId);
          Get.snackbar("Removed", data['message'] ?? 'Book removed from favorites');
        } else {
          Get.snackbar("Error", data['message'] ?? 'Failed to remove book');
        }
      } else {
        Get.snackbar("Error", "Failed to remove book. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error removing book: $e');
      Get.snackbar("Error", "Network error occurred");
    }
  }

  // Remove movie from favorites
  Future<void> removeMovieFromFavorites(String movieId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl?action=remove&user_id=$currentUserId&item_id=$movieId&item_type=movie'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          favoriteMovies.removeWhere((movie) => movie['id'].toString() == movieId);
          Get.snackbar("Removed", data['message'] ?? 'Movie removed from favorites');
        } else {
          Get.snackbar("Error", data['message'] ?? 'Failed to remove movie');
        }
      } else {
        Get.snackbar("Error", "Failed to remove movie. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error removing movie: $e');
      Get.snackbar("Error", "Network error occurred");
    }
  }

  // Get total favorites count
  int get totalFavoritesCount => favoriteBooks.length + favoriteMovies.length;

  // Get all favorites combined (for mixed display)
  List<Map<String, dynamic>> get allFavorites {
    List<Map<String, dynamic>> combined = [];

    // Add books with type identifier
    for (var book in favoriteBooks) {
      var bookWithType = Map<String, dynamic>.from(book);
      bookWithType['type'] = 'book';
      combined.add(bookWithType);
    }

    // Add movies with type identifier
    for (var movie in favoriteMovies) {
      var movieWithType = Map<String, dynamic>.from(movie);
      movieWithType['type'] = 'movie';
      combined.add(movieWithType);
    }

    return combined;
  }

  // Refresh favorites from server
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }
}