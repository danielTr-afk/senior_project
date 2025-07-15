import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BooksController extends GetxController {
  var books = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/BookFlix/book.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data']['books'] != null) {
          books.value = List<Map<String, dynamic>>.from(jsonData['data']['books']);
          books.sort((a, b) => b['likes'].compareTo(a['likes']));
        } else {
          Get.snackbar("No Data", "No books found.");
        }
      } else {
        Get.snackbar("Error", "Failed to load books. Code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
