import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/authController/signUpGetX.dart';
import '../../GlobalWideget/styleText.dart';

class SignButton extends StatelessWidget {
   SignButton({
    super.key, required this.text, required this.color,
  });

  // final void Function()? onPressed;
  final String text;
  final Color color;
  signUpGetx controller = Get.put(signUpGetx());


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 60,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          onPressed: () {
            controller.signup(controller.name.value.text, controller.email.value.text, controller.password.value.text);
          },
          child: styleText(
              text: text, fSize: 20, color: Colors.white)),
    );
  }
}