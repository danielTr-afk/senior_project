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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor2,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Header icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: Icon(Icons.arrow_back_ios, color: textColor2,)),
                  Icon(Icons.edit, color: textColor2,),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Profile photo
            Obx(() => CircleAvatar(
              backgroundImage: NetworkImage(loginController.profileImage.value),
              radius: 100,
            )),

            const SizedBox(height: 10),

             styleText(text: loginController.userName.value, fSize: 24, color: textColor2, fontWeight: FontWeight.bold,),
             Text(
              'California, USA',
              style: TextStyle(color: mainColor2),
            ),

            const SizedBox(height: 20),

            /// Stats cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  StatCard(label: 'Role', value: 'Author'),
                  StatCard(label: 'Gender', value: 'Male'),
                  StatCard(label: 'Phone', value: '76544344'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Options list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const MenuTile(icon: Icons.person, title: 'Personal Information'),
                  const MenuTile(icon: Icons.favorite, title: 'Your Favourites'),
                  const MenuTile(icon: Icons.settings, title: 'Setting', ontap: "/settingsPage",),
                  const MenuTile(icon: Icons.person_pin, title: 'About Us', ontap: "/AboutUsPage",),
                  const MenuTile(icon: Icons.question_mark, title: 'Help', ontap: "/HelpPage",),
                  Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(Icons.logout, color: secondaryColor),
                      title:  styleText(text: "Logout", fSize: 18, color: textColor2,),
                      trailing:  Icon(Icons.arrow_forward_ios, size: 16, color: textColor2,),
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



