// controllers/book_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';

import '../authController/loginGetX.dart';

class addBookController extends GetxController {
  var isLoading = false.obs;
  var selectedCategory = ''.obs;
  var bookName = ''.obs;
  var description = ''.obs;

  File? coverImage;
  File? pdfFile;

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  // Update the submitBook method in book_controller.dart
  Future<void> submitBook() async {
    final authController = Get.find<loginGetx>();
    final userId = authController.userId.value;

    if (userId == 0) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    if (bookName.value.isEmpty || selectedCategory.value.isEmpty || description.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2/BookFlix/add_book.php'),
      );

      // Add all required fields
      request.fields['title'] = bookName.value;
      request.fields['category'] = selectedCategory.value;
      request.fields['description'] = description.value;
      request.fields['submitted_by'] = userId.toString();  // Use the logged-in user's ID

      // Add image file if selected
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

      // Add PDF file if selected
      if (pdfFile != null) {
        var stream = http.ByteStream(DelegatingStream.typed(pdfFile!.openRead()));
        var length = await pdfFile!.length();
        var multipartFile = http.MultipartFile(
          'pdf',
          stream,
          length,
          filename: basename(pdfFile!.path),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print('Raw server response: $responseData'); // Debugging

      if (response.statusCode == 200) {
        var result = json.decode(responseData);
        if (result['success'] == true) {
          Get.back();
          Get.snackbar('Success', result['message'] ?? 'Book submitted for approval');
        } else {
          Get.snackbar('Error', result['message'] ?? 'Submission failed');
          if (result['errors'] != null) {
            // Show detailed validation errors if available
            result['errors'].forEach((field, error) {
              Get.snackbar('Validation Error', '$field: $error');
            });
          }
        }
      } else {
        Get.snackbar('Error', 'Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit book: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}