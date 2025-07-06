import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class otpController extends GetxController {
  var otpCode = ''.obs;
  var isLoading = false.obs;

  void updateOtp(String code) {
    otpCode.value = code;
  }

  Future<void> verifyOtp() async {
    if (otpCode.value.length != 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
      return;
    }

    isLoading.value = true;

    final url = Uri.parse('http://10.0.2.2/f-book/verify_otp.php');
    final response = await http.post(
      url,
      body: {
        'otp': otpCode.value,
      },
      headers: {
        'Accept': 'application/json',
      },
    );

    isLoading.value = false;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        Get.snackbar('Success', data['message']);
        Get.offAllNamed('/resetPassword');
      } else {
        Get.snackbar('Error', data['message']);
      }
    } else {
      Get.snackbar('Error', 'Server error. Please try again.');
    }
  }
}
