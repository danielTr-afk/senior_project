import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'settingWideget/SettingsTile.dart';

class settingsPage extends StatelessWidget {
  const settingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: blackColor2,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.35,
              color: secondaryColor,
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      styleText(text: "Setting", fSize: 30, color: textColor2, fontWeight: FontWeight.bold,),
                      const Spacer(),
                      Icon(Icons.settings, color: textColor2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/45.jpg'),
                      ),
                      const SizedBox(width: 10),
                      styleText(text: "Soylent Corp", fSize: 20, color: textColor2)
                    ],
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -140),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor2!,
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: const [
                      SettingsTile(icon: Icons.notifications, title: 'Turn on notifications'),
                      Divider(),
                      SettingsTile(icon: Icons.phone, title: 'Change phone number'),
                      Divider(),
                      SettingsTile(icon: Icons.password, title: 'Change password'),
                      Divider(),
                      SettingsTile(icon: Icons.invert_colors_on, title: 'Change app color'),
                      Divider(),
                      SettingsTile(icon: Icons.logout, title: 'Logout'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), // Extra space at bottom
          ],
        ),
      ),
    );
  }
}

