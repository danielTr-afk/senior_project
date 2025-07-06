import 'package:f_book2/view/auth/authWideget/authTextForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/variables.dart';
import '../../controller/authController/updatePassController.dart';
import '../GlobalWideget/styleText.dart';

class updatePassword extends StatelessWidget {
  final controller = Get.put(updatePassController());
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
                styleText(text: "Update your Password", fSize: 50, color: textColor2, textAlign: TextAlign.center,),
                styleText(text: "Enter your new Password here", fSize: 20, color: textColor2),
                const SizedBox(height: 20),
                authTextForm(hint: "New Password", sufIcon: Icon(Icons.lock), obscure: false, textFormController: controller.passwordController,),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.resetPassword,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      :  styleText(text: "Update", fSize: 20, color: textColor2),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
