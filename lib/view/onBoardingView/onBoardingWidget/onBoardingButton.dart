import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/onBoarding/onBoardingGetX.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class onBoardingButton extends StatelessWidget {
  const onBoardingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<onboradingGetx>();
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.color.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: controller.next,
          child: styleText(
            text: controller.buttonText.value,
            fSize: 30,
            color: textColor2,
          ),
        ),
      );
    });
  }
}