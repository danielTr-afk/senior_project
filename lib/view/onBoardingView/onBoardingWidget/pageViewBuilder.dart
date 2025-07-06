import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../controller/onBoarding/onBoardingGetX.dart';
import '../../../controller/onBoarding/onBoardingListItem.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class pageViewBuilder extends GetView<onboradingGetx> {
  const pageViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      itemCount: onboardingList.length,
      onPageChanged: (val) {
        controller.onPageChanged(val);
      },
      itemBuilder: (context, index) => Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                styleText(
                  textAlign: TextAlign.center,
                  text: onboardingList[index].title!,
                  fSize: 40,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
                styleText(
                  textAlign: TextAlign.center,
                  text: onboardingList[index].description!,
                  fSize: 30,
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
                SmoothPageIndicator(
                  controller: controller.pageController,
                  count: 3,
                  effect: WormEffect(spacing: 10, activeDotColor: secondaryColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
