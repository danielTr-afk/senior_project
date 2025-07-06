import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/onBoarding/onBoardingGetX.dart';
import '../../../controller/onBoarding/onBoardingListItem.dart';
import '../../../controller/variables.dart';
import 'clipper.dart';

class onBoardingStack extends GetView<onboradingGetx> {
  const onBoardingStack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: CurvedBackgroundClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [mainColor, secondaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(110))),
          ),
        ),
        Obx(
              () => CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.4,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(
                onboardingList[controller.currentPage.value].image!),
          ),
        )
      ],
    );
  }
}

