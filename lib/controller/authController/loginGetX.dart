import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class loginGetx extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userId = 0.obs;
  var profileImage = ''.obs;

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

    final url = Uri.parse("http://10.0.2.2/BookFlix/login.php");

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },body: jsonEncode({
            "email": email,
            "password": password,
          }));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          userName.value = json['data']['name'];
          userEmail.value = json['data']['email'];
          userId.value = json['data']['id'];
          profileImage.value = json['data']['profile_image'] ?? '';
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

  void updateProfileImage(String imageUrl) {
    profileImage.value = imageUrl;
  }
}