import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/authController/loginGetX.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';
import 'homeListTile.dart';

class homeDrawer extends StatelessWidget {
  homeDrawer({
    super.key,
  });

  final loginController = Get.find<loginGetx>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      shadowColor: Colors.black,
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [mainColor, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Obx(() {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  backgroundColor: mainColor,
                  backgroundImage:
                      AssetImage("images/onBoardingImage/onboardingphoto1.png"),
                  radius: MediaQuery.of(context).size.width * 0.25,
                ),
                IconButton(onPressed: (){

                }, icon: Icon(Icons.photo_camera)),
                SizedBox(
                  height: 10,
                ),
                styleText(
                  text: loginController.userName.value,
                  fSize: 30,
                  color: textColor1,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                styleText(
                  text: loginController.userEmail.value,
                  fSize: 17,
                  color: textColor1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                homeListTile(icon: Icons.person, text: "Profile", onTap: ''),
                homeListTile(icon: Icons.settings, text: "Settings", onTap: ''),
                homeListTile(
                    icon: Icons.arrow_right_alt,
                    text: "Logout",
                    onTap: '/login')
              ],
            );
          })),
    );
  }
}
