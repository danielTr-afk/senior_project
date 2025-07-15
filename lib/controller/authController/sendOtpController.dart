import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class sendOtpController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/send_otp.php'),
        body: {'email': email},
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      isLoading.value = false;

      if (data['success'] == true) {
        Get.snackbar('Success', data['message']);
        Get.toNamed('/otp'); // navigate to OTP input screen
      } else {
        Get.snackbar('Failed', data['message']);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Connection failed');
    }
  }
}
