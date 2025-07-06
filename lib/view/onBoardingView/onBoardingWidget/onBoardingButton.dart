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
    return GetBuilder<onboradingGetx>(
        builder: (c) => Container(
          margin: EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: c.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                c.next();
              },
              child: styleText(text: c.buttonText, fSize: 20, color: textColor2,)),
        ));
  }
}


