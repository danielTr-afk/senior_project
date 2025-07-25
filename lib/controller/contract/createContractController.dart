import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import '../authController/loginGetX.dart';

class CreateContractController extends GetxController {
  final TextEditingController personController = TextEditingController();
  final TextEditingController bookController = TextEditingController();
  final TextEditingController filmController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController royaltyController = TextEditingController();
  final TextEditingController additionalTermsController = TextEditingController();

  // Changed from ValueNotifier to RxString
  final RxString changesAllowedPercentage = '10%'.obs;
  // Changed from ValueNotifier to RxnString (nullable RxString)
  final RxnString signatureImagePath = RxnString();

  final RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  final RxBool loadingUsers = false.obs;
  final RxBool isSubmitting = false.obs; // Add loading state for submission
  final ImagePicker picker = ImagePicker();

  // Make these reactive for better state management
  final RxnInt receiverId = RxnInt();
  final RxnInt bookId = RxnInt();

  void selectPerson(Map<String, dynamic> person) {
    personController.text = person['name'].toString();
    // Handle both String and int types for ID
    int? id = person['id'] is String ? int.tryParse(person['id']) : person['id'];
    receiverId.value = id;
    print('Selected person: ${person['name']}, ID: $id'); // Debug print
  }

  void selectBook(Map<String, dynamic> book) {
    bookController.text = book['title'].toString();
    // Handle both String and int types for ID
    int? id = book['id'] is String ? int.tryParse(book['id']) : book['id'];
    bookId.value = id;
    print('Selected book: ${book['title']}, ID: $id'); // Debug print
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) return;

    loadingUsers.value = true;
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/BookFlix/get_users.php'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          users.value = List<Map<String, dynamic>>.from(jsonData['users'])
              .where((user) => user['name'].toString().toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load users");
    } finally {
      loadingUsers.value = false;
    }
  }

  Future<void> pickSignatureImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        signatureImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  final loginGetx _authController = Get.find<loginGetx>(); // Get the auth controller

  Future<void> sendContract({
    required BuildContext context,
  }) async {
    // Validate required fields
    if (bookId.value == null || receiverId.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a person and a book')),
      );
      return;
    }

    if (priceController.text.isEmpty || royaltyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in price and royalty percentage')),
      );
      return;
    }

    if (dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a contract date')),
      );
      return;
    }

    // Validate numeric inputs
    final agreedPrice = double.tryParse(priceController.text);
    final royaltyPercentage = double.tryParse(royaltyController.text);

    if (agreedPrice == null || agreedPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price greater than 0')),
      );
      return;
    }

    if (royaltyPercentage == null || royaltyPercentage <= 0 || royaltyPercentage > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Royalty percentage must be between 0 and 100')),
      );
      return;
    }

    // Debug prints to check auth values
    print('Auth User ID: ${_authController.userId.value}');
    print('Auth User Role: ${_authController.userRole.value}');
    print('Selected Book ID: ${bookId.value}');
    print('Selected Receiver ID: ${receiverId.value}');

    isSubmitting.value = true; // Start loading

    try {
      final requestBody = {
        'user_id': _authController.userId.value,
        'user_role': _authController.userRole.value,
        'book_id': bookId.value,
        'receiver_id': receiverId.value,
        'agreed_price': agreedPrice,
        'royalty_percentage': royaltyPercentage,
        'additional_terms': additionalTermsController.text.isEmpty ? null : additionalTermsController.text,
        'max_changes_allowed': changesAllowedPercentage.value,
        'contract_date': dateController.text,
        'expiry_date': expiryDateController.text.isEmpty ? null : expiryDateController.text,
      };

      print('Sending contract with data: ${json.encode(requestBody)}'); // Debug print

      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/send_contract.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseData['message']),
                backgroundColor: Colors.green,
              ),
            );
            clearForm();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseData['message'] ?? 'Unknown error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          print('JSON decode error: $e'); // Debug print
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid server response format'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // For 400 errors, try to parse the error message from response
        String errorMessage = 'Server error: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        } catch (e) {
          // If can't parse JSON, use default message
          print('Could not parse error response: $e');
        }

        print('HTTP Error: ${response.statusCode} - ${response.body}'); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Exception: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isSubmitting.value = false; // Stop loading
    }
  }

  void clearForm() {
    personController.clear();
    bookController.clear();
    filmController.clear();
    dateController.clear();
    expiryDateController.clear();
    priceController.clear();
    royaltyController.clear();
    additionalTermsController.clear();
    changesAllowedPercentage.value = '10%';
    signatureImagePath.value = null;
    receiverId.value = null;
    bookId.value = null;
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is destroyed
    personController.dispose();
    bookController.dispose();
    filmController.dispose();
    dateController.dispose();
    expiryDateController.dispose();
    priceController.dispose();
    royaltyController.dispose();
    additionalTermsController.dispose();
    super.onClose();
  }
}