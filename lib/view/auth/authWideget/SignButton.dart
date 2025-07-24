import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/authController/signUpGetX.dart';
import '../../GlobalWideget/styleText.dart';

class SignButton extends StatelessWidget {
  SignButton({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;
  final signUpGetx controller = Get.find<signUpGetx>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50, // Slightly reduced height for better proportion
      child: Obx(
            () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: controller.isloading.value ? null : () {
            controller.signup();
          },
          child: controller.isloading.value
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : styleText(
            text: text,
            fSize: 18, // Slightly reduced font size
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}