import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../view/auth/signup.dart';
import '../variables.dart';
import 'onBoardingListItem.dart';

class onboradingGetx extends GetxController {
  final RxInt currentPage = 0.obs;
  late final PageController pageController;
  final Rx<Color> color = mainColor.obs;
  final RxString buttonText = "Next".obs;

  void onPageChanged(int index) {
    currentPage.value = index.clamp(0, onboardingList.length - 1);
    _updateButtonState();
  }

  void next() {
    final nextPage = currentPage.value + 1;


    if (nextPage >= onboardingList.length) {
      Get.offAll(() => const signup());
      return;
    }

    currentPage.value = nextPage;
    pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _updateButtonState();
  }

  void _updateButtonState() {
    if (currentPage.value == onboardingList.length - 1) {
      buttonText.value = "Get Started";
      color.value = secondaryColor;
    } else {
      buttonText.value = "Next";
      color.value = mainColor;
    }
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}