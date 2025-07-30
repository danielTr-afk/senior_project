import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:f_book2/view/userProfile/userProfileWideget/MenuTile.dart';
import 'package:f_book2/view/userProfile/userProfileWideget/StatCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController/loginGetX.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final loginController = Get.find<loginGetx>();

  String getRoleName(int roleId) {

    switch (roleId) {
      case 2:
        return 'Author';
      case 3:
        return 'Director';
      case 4:
        return 'Member';
      case 5:
        return 'Author/Director';
      default:
        return 'Unknown Role';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor2,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios, color: textColor2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Obx(() => CircleAvatar(
              backgroundImage: NetworkImage(
                loginController.profileImage.value.isNotEmpty
                    ? loginController.profileImage.value
                    : 'https://randomuser.me/api/portraits/men/1.jpg', // Default image
              ),
              radius: 100,
            )),

            const SizedBox(height: 10),

            Obx(() => styleText(
              text: loginController.userName.value,
              fSize: 24,
              color: textColor2,
              fontWeight: FontWeight.bold,
            )),

            Obx(() => Text(
              loginController.userEmail.value,
              style: TextStyle(color: mainColor2),
            )),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                  children: [
                  Obx(() => StatCard(
              label: 'Role',
              value: getRoleName(loginController.userRole.value),
            )),
                    Obx(() => StatCard(
                      label: 'Gender',
                      value: loginController.userGender.value == 'Not specified'
                          ? 'Not set'
                          : loginController.userGender.value,
                    )),

                    Obx(() => StatCard(
                      label: 'Phone',
                      value: loginController.userPhone.value == 'Not provided'
                          ? 'Not set'
                          : loginController.userPhone.value,
                    )),
          ],
        ),
      ),

      const SizedBox(height: 20),

      Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const MenuTile(icon: Icons.favorite, title: 'Your Favourites', ontap: "/FavoritesPage",),
            const MenuTile(icon: Icons.settings, title: 'Setting', ontap: "/settingsPage"),
            const MenuTile(icon: Icons.person_pin, title: 'About Us', ontap: "/AboutUsPage"),
            const MenuTile(icon: Icons.question_mark, title: 'Help', ontap: "/HelpPage"),
            Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(Icons.logout, color: secondaryColor),
                title: styleText(text: "Logout", fSize: 18, color: textColor2),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textColor2),
                tileColor: mainColor,
                onTap: () {
                  Get.offAllNamed("/login");
                },
              ),
            )
          ],
        ),
      ),
      ],
    ),
    ),
    );
  }
}