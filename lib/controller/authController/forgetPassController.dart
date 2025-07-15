import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class forgetPassController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;
  var otp = ''.obs;
  var email = ''.obs;

  void sendOtp() async {
    final enteredEmail = emailController.text;
    if (enteredEmail.isEmpty) {
      Get.snackbar("Error", "Email required");
      return;
    }

    isLoading.value = true;

    final response = await http.post(
      Uri.parse("http://10.0.2.2/BookFlix/send_otp.php"),
      body: {'email': enteredEmail},
    );

    final data = jsonDecode(response.body);
    isLoading.value = false;

    if (data['success'] == true) {
      otp.value = data['otp'].toString();
      email.value = data['email'].toString();
      Get.toNamed('/otp');
    } else {
      Get.snackbar("Error", data['message']);
    }
  }
}
