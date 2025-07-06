import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class loginGetx extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  var userName = ''.obs;
  var userEmail = ''.obs;

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  goToSignUp(){
    Get.offAllNamed("/signup");
  }

  goToHomePage(){
    Get.offAllNamed("/homePage");
  }

  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    final url = Uri.parse("http://10.0.2.2/f-book/login.php");

    try {
      final response = await http.post(url, body: jsonEncode({
        "email": email,
        "password": password,
      }));


      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          userName.value = json['data']['name'];
          userEmail.value = json['data']['email'];
          Get.snackbar("Success", json['message']);
          Get.offAllNamed("/homePage");
        } else {
          Get.snackbar("Error", json['message']);
        }
      } else {
        Get.snackbar("false", " code of response: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("false", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

