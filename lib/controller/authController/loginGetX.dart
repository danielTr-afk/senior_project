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
  var userRole = 0.obs;
  var userPhone = ''.obs; // Added phone observable
  var userGender = ''.obs; // Added gender observable

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
          },
          body: jsonEncode({
            "email": email,
            "password": password,
          }));

      print("Raw API response: ${response.body}"); // Add this debug line

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          final data = json['data'] ?? {};
          print("API data: $data"); // Debug the complete data object

          userName.value = data['name']?.toString() ?? 'Unknown';
          userEmail.value = data['email']?.toString() ?? '';
          userId.value = int.tryParse(data['id']?.toString() ?? '') ?? 0;
          userRole.value = int.tryParse(data['role_id']?.toString() ?? '') ?? 0;
          profileImage.value = data['profile_image']?.toString() ?? '';

          // Updated phone and gender handling
          userPhone.value = data['phone']?.toString() ?? 'Not provided';
          userGender.value = data['gender']?.toString() ?? 'Not specified';

          // Debug the values being set
          print("Setting values:");
          print("Phone: ${userPhone.value}");
          print("Gender: ${userGender.value}");

          Get.snackbar("Success", json['message']?.toString() ?? 'Login successful');
          Get.offAllNamed("/homePage");
        } else {
          Get.snackbar("Error", json['message']?.toString() ?? 'Login failed');
        }
      } else {
        Get.snackbar("Error", "Server responded with status code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
      print("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfileImage(String imageUrl) {
    profileImage.value = imageUrl;
  }
}