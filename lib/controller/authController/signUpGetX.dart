import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class signUpGetx extends GetxController {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  var isloading = false.obs;
  var gender = "Male".obs;
  var isAuthor = false.obs;
  var isDirector = false.obs;

  @override
  void onInit() {
    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  goToLogin() {
    Get.offAllNamed("/login");
  }

  Future<void> signup() async {
    // Basic validation
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (password.text != confirmPassword.text) {
      Get.snackbar("Error", "Passwords don't match",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isloading.value = true;

    try {
      print("Sending signup request..."); // Debug log

      final response = await http.post(
        Uri.parse("http://10.0.2.2/BookFlix/signnup.php"),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "name": name.text.trim(),
          "email": email.text.trim().toLowerCase(),
          "phone": phone.text.trim(),
          "password": password.text,
          "gender": gender.value,
          "is_author": isAuthor.value ? "1" : "0",
          "is_director": isDirector.value ? "1" : "0",
          "is_member": (!isAuthor.value && !isDirector.value) ? "1" : "0"
        },
      );

      print("Response status: ${response.statusCode}"); // Debug log
      print("Response body: ${response.body}"); // Debug log

      if (response.statusCode == 200) {
        // Check if response is valid JSON
        try {
          final result = jsonDecode(response.body);

          if (result['status'] == "success") {
            Get.snackbar("Success", result['message'],
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white);
            Get.offAllNamed("/login");
          } else {
            Get.snackbar("Error", result['message'] ?? "Unknown error",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white);
          }
        } catch (jsonError) {
          print("JSON parsing error: $jsonError");
          Get.snackbar("Error", "Server returned invalid response",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print("Network error: $e");
      Get.snackbar("Error", "Network error: Please check your connection",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isloading.value = false;
    }
  }
}