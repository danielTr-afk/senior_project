import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class signUpGetx extends GetxController {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  var isloading = false.obs;

  @override
  void onInit() {
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  goToLogin() {
    Get.offAllNamed("/login");
  }

  Future<void> signup(String name, String email, String password) async {
    isloading.value = true;

    final url = Uri.parse("http://10.0.2.2/BookFlix/signup.php");

    try {
      final response = await http.post(url,
          body: {"name": name, "email": email, "password": password});
      if (response.statusCode == 200) {
        final result = response.body;
        final json = jsonDecode(result);

        if (json['status'] == "success") {
          Get.snackbar("Success", json['message']);
          Get.offAllNamed("/login");
        } else {
          Get.snackbar("Error", json['message']);
        }
      } else {
        Get.snackbar("Error", "Server error");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
      isloading.value = false;
  }
}

