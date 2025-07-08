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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: onBoardingStack(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4, // Adjust as needed
                child: pageViewBuilder(),
              ),
              onBoardingButton(),
            ],
          ),
        ),
      ),
    );
  }
}