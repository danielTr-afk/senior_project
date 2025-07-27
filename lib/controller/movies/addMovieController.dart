// controllers/movie_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';

import '../authController/loginGetX.dart';

class addMovieController extends GetxController {
  var isLoading = false.obs;
  var isLoadingBooks = false.obs;
  var selectedCategory = ''.obs;
  var selectedBookId = 0.obs;
  var movieName = ''.obs;
  var description = ''.obs;
  var books = <Map<String, dynamic>>[].obs;

  File? coverImage;
  File? trailerFile;
  File? movieFile;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    update();
  }

  void setSelectedBook(int bookId) {
    selectedBookId.value = bookId;
    update();
  }

  Future<void> fetchBooks() async {
    isLoadingBooks.value = true;
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/BookFlix/book.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data']['books'] != null) {
          books.value = List<Map<String, dynamic>>.from(jsonData['data']['books']);
          print('Books loaded: ${books.length}');
        } else {
          print("No books found in response");
        }
      } else {
        print("Failed to load books. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception loading books: $e");
    } finally {
      isLoadingBooks.value = false;
    }
  }

  String getSelectedBookTitle() {
    if (selectedBookId.value == 0) return "Select a book (Optional)";

    try {
      final book = books.firstWhere(
            (book) => book['id'] == selectedBookId.value,
        orElse: () => <String, dynamic>{},
      );
      return book.isNotEmpty ? book['title'] ?? 'Unknown Book' : 'Book not found';
    } catch (e) {
      return 'Book not found';
    }
  }

  Future<void> submitMovie() async {
    final authController = Get.find<loginGetx>();
    final userId = authController.userId.value;

    if (userId == 0) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    // Debug: Print the values to check what's being validated
    print('Movie Name: "${movieName.value}"');
    print('Category: "${selectedCategory.value}"');
    print('Description: "${description.value}"');
    print('Selected Book ID: ${selectedBookId.value}');

    // Fixed validation logic - check .value and use trim() to remove whitespace
    if (movieName.value.trim().isEmpty ||
        selectedCategory.value.trim().isEmpty ||
        description.value.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2/BookFlix/add_movie.php'),
      );

      // Add all required fields with trimmed values
      request.fields['title'] = movieName.value.trim();
      request.fields['category'] = selectedCategory.value.trim();
      request.fields['description'] = description.value.trim();
      request.fields['director_id'] = userId.toString();

      // Add book_id if selected (0 means no book selected)
      if (selectedBookId.value > 0) {
        request.fields['book_id'] = selectedBookId.value.toString();
      }

      // Add cover image if selected
      if (coverImage != null) {
        var stream = http.ByteStream(DelegatingStream.typed(coverImage!.openRead()));
        var length = await coverImage!.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(coverImage!.path),
        );
        request.files.add(multipartFile);
      }

      // Add trailer file if selected
      if (trailerFile != null) {
        var stream = http.ByteStream(DelegatingStream.typed(trailerFile!.openRead()));
        var length = await trailerFile!.length();
        var multipartFile = http.MultipartFile(
          'trailer',
          stream,
          length,
          filename: basename(trailerFile!.path),
        );
        request.files.add(multipartFile);
      }

      // Add movie file if selected
      if (movieFile != null) {
        var stream = http.ByteStream(DelegatingStream.typed(movieFile!.openRead()));
        var length = await movieFile!.length();
        var multipartFile = http.MultipartFile(
          'movie_file',
          stream,
          length,
          filename: basename(movieFile!.path),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var result = json.decode(responseData);

      print('Server response: $responseData'); // Debug print

      if (response.statusCode == 200) {
        if (result['success'] == true) {
          Get.back();
          Get.snackbar('Success', result['message'] ?? 'Movie submitted successfully');
        } else {
          Get.snackbar('Error', result['message'] ?? 'Submission failed');
          if (result['errors'] != null) {
            result['errors'].forEach((field, error) {
              Get.snackbar('Validation Error', '$field: $error');
            });
          }
        }
      } else {
        Get.snackbar('Error', 'Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit movie: ${e.toString()}');
      print('Error submitting movie: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add a method to clear all fields (optional, for testing)
  void clearFields() {
    movieName.value = '';
    selectedCategory.value = '';
    description.value = '';
    selectedBookId.value = 0;
    coverImage = null;
    trailerFile = null;
    movieFile = null;
    update();
  }
}