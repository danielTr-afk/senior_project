import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BooksController extends GetxController {
  var books = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  void fetchBooks() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('http://10.0.2.2/f-book/book.php'));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        books.value = jsonData['data']['books'];
      } else {
        Get.snackbar("Error", "Failed to load books");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
    books.value.sort((a, b) => b['likes'].compareTo(a['likes']));
  }
}
