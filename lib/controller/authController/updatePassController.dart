import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class updatePassController extends GetxController {
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> resetPassword() async {
    final newPassword = passwordController.text.trim();

    if (newPassword.isEmpty) {
      Get.snackbar('Error', 'Please enter a new password');
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters long');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/f-book/update_password.php'),
        body: {
          'new_pass': newPassword,
        },
        headers: {
          'Accept': 'application/json',
        },
      );

      final data = json.decode(response.body);
      isLoading.value = false;

      if (data['success'] == true) {
        Get.snackbar('Success', data['message']);
        Get.offAllNamed('/login'); // Redirect to login page
      } else {
        Get.snackbar('Error', data['message']);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}
