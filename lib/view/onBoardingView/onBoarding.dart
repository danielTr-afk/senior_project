import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onBoarding/onBoardingGetX.dart';
import 'onBoardingWidget/onBoardingButton.dart';
import 'onBoardingWidget/onBoardingStack.dart';
import 'onBoardingWidget/pageViewBuilder.dart';

class onBoarding extends GetView<onboradingGetx> {
  onBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          onBoardingStack(),
          Expanded(
            child: pageViewBuilder(),
          ),
          onBoardingButton(),
        ],
      ),
    );
  }
}
