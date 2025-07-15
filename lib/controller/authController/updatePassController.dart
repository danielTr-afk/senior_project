import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'forgetPassController.dart';

class updatePassController extends GetxController {
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> resetPassword() async {
    final password = passwordController.text.trim();
    final email = Get.find<forgetPassController>().email.value;

    if (password.isEmpty || password.length < 8) {
      Get.snackbar('Error', 'Enter a password with at least 8 characters');
      return;
    }

    isLoading.value = true;

    final response = await http.post(
      Uri.parse('http://10.0.2.2/BookFlix/update_password.php'),
      body: {
        'new_pass': password,
        'email': email,
      },
    );

    isLoading.value = false;

    final data = json.decode(response.body);
    if (data['success']) {
      Get.snackbar('Success', data['message']);
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Error', data['message']);
    }
  }
}
