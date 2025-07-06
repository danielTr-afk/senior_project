
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../view/auth/signup.dart';
import '../variables.dart';
import 'onBoardingListItem.dart';

class onboradingGetx extends GetxController {
  RxInt currentPage = 0.obs;
  late PageController pageController;
  Color color = mainColor;
  String buttonText = "Next";

  onPageChanged(int index) {
    currentPage.value = index;
    update();
  }

  next() {
    currentPage++;
    if (currentPage.value > onboardingList.length - 1) {
      Get.offAll(signup());
    }
    if (currentPage.value == onboardingList.length - 1) {
      buttonText = "Get Started";
      color = secondaryColor;
    }
    pageController.animateToPage(currentPage.value,
        duration: Duration(microseconds: 900), curve: Curves.bounceInOut);
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }
}
