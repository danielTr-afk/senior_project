import 'package:f_book2/controller/authController/loginGetX.dart';
import 'package:get/get.dart';
import 'authController/forgetPassController.dart';
import 'onBoarding/onBoardingGetX.dart';

class mybindings implements Bindings{
  void dependencies() {
    Get.put(onboradingGetx());
    Get.put(loginGetx(), permanent: true);
    Get.put(forgetPassController());
  }
}