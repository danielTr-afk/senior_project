import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import '../authController/loginGetX.dart';

class addBookController extends GetxController {
  var isLoading = false.obs;
  var selectedCategory = ''.obs;
  var bookName = ''.obs;
  var description = ''.obs;

  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? coverImage;
  File? pdfFile;

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  @override
  void onInit() {
    super.onInit();
    bookNameController.addListener(() => bookName.value = bookNameController.text);
    descriptionController.addListener(() => description.value = descriptionController.text);
  }

  @override
  void onClose() {
    bookNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

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

      // Add text fields
      request.fields.addAll({
        'title': bookName.value.trim(),
        'category': selectedCategory.value,
        'description': description.value.trim(),
        'author_id': userId.toString(),
        'price': '0.00',
      });

      // Add files
      if (coverImage != null) {
        var imageStream = http.ByteStream(coverImage!.openRead());
        var imageLength = await coverImage!.length();
        var imageFile = http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: basename(coverImage!.path),
        );
        request.files.add(imageFile);
      }

      if (pdfFile != null) {
        var pdfStream = http.ByteStream(pdfFile!.openRead());
        var pdfLength = await pdfFile!.length();
        var pdfMultipartFile = http.MultipartFile(
          'pdf',
          pdfStream,
          pdfLength,
          filename: basename(pdfFile!.path),
        );
        request.files.add(pdfMultipartFile);
      }

      print('Sending request to: ${request.url}');
      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.map((f) => f.field + ': ' + (f.filename ?? 'no filename')).toList()}');

      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Raw server response: "$responseString"');

      if (response.statusCode == 200) {
        // Check if response starts with valid JSON
        if (responseString.trim().startsWith('{')) {
          try {
            final responseJson = json.decode(responseString) as Map<String, dynamic>;

            if (responseJson['success'] == true) {
              // Clear form
              bookNameController.clear();
              descriptionController.clear();
              selectedCategory.value = '';
              coverImage = null;
              pdfFile = null;
              update();

              Get.back();
              Get.snackbar(
                'Success',
                responseJson['message'] ?? 'Book added successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
            } else {
              throw Exception(responseJson['message'] ?? 'Submission failed');
            }
          } catch (jsonError) {
            print('JSON decode error: $jsonError');
            throw Exception('Server returned invalid JSON response');
          }
        } else {
          print('Response does not start with JSON: ${responseString.substring(0, responseString.length > 100 ? 100 : responseString.length)}');
          throw Exception('Server returned non-JSON response. Check server logs.');
        }
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in submitBook: $e');
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}