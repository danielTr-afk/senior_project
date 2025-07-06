import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class forgetPassController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> sendEmailForOTP() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return;
    }

    isLoading.value = true;

    final url = Uri.parse('http://10.0.2.2/f-book/forgot_password.php'); // Adjust this
    final response = await http.post(
      url,
      body: {'email': email},
      headers: {'Accept': 'application/json'},
    );

    isLoading.value = false;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        Get.snackbar('Success', data['message']);
        Get.toNamed('/otp'); // Navigate to OTP screen
      } else {
        Get.snackbar('Error', data['message']);
      }
    } else {
      Get.snackbar('Error', 'Server error. Please try again later.');
    }
  }
}
