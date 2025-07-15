import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/userProfile/userProfileWideget/MenuTile.dart';
import 'package:f_book2/view/userProfile/userProfileWideget/StatCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user.jpg'), // Replace with NetworkImage if needed
            ),

            const SizedBox(height: 10),

            /// Name and location
             Text(
              'Johan Smith',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor2),
            ),
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
                children: const [
                  MenuTile(icon: Icons.person, title: 'Personal Information'),
                  MenuTile(icon: Icons.favorite, title: 'Your Favourites'),
                  MenuTile(icon: Icons.settings, title: 'Setting'),
                  MenuTile(icon: Icons.person_pin, title: 'About Us'),
                  MenuTile(icon: Icons.question_mark, title: 'Help'),
                  MenuTile(icon: Icons.logout, title: 'Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



