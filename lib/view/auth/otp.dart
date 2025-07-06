
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../controller/authController/forgetPassController.dart';
import '../../controller/authController/otpController.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';

class otp extends StatelessWidget {
  final otpController controller = Get.put(otpController());
  final emailController = Get.find<forgetPassController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: mainColor,
        child: Center(
          child: Container(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                styleText(text: "Verification", fSize: 50, color: textColor2, textAlign: TextAlign.center, fontWeight: FontWeight.bold,),
                styleText(text: "Enter the code sent to the email \n ${emailController.emailController.value.text}", fSize: 20, color: textColor2, textAlign: TextAlign.center,),
                Pinput(
                  length: 6,
                  onChanged: controller.updateOtp,
                  onCompleted: (pin) => controller.updateOtp(pin),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.verifyOtp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: styleText(text: "Verify", fSize: 20, color: textColor2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
