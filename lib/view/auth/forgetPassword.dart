import 'package:f_book2/view/auth/authWideget/authTextForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/authController/sendOtpController.dart';
import '../../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';

class forgotPassword extends StatelessWidget {
  final controller = Get.put(sendOtpController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: mainColor,
        child: Center(
          child: Container(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                styleText(text: "Forgot Password", fSize: 50, color: textColor2),
                styleText(text: "Enter your email to receive OTP", fSize: 20, color: textColor2),
                const SizedBox(height: 20),
                authTextForm(hint: "email", sufIcon: Icon(Icons.email_outlined), obscure: false, textFormController: controller.emailController,),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.sendOtp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      :  styleText(text: "Send OTP", fSize: 20, color: textColor2),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
