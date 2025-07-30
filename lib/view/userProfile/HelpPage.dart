import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import '../Message/message.dart';


class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: styleText(
          text: 'BookFlix Help Center',
          fSize: 25,
          color: textColor2,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios, color: textColor2,)),
        backgroundColor: blackColor2,
        iconTheme: IconThemeData(color: textColor2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            styleText(
              text: 'Understanding Your Role on BookFlix',
              fSize: 27,
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20),
            styleText(
              text: 'BookFlix offers different functionalities based on your account type. Below you can explore what you can do as a Member, Author, or Director.',
              fSize: 19,
              color: textColor2,
            ),
            SizedBox(height: 40),

            // Member Section
            _buildRoleSection(
              number: '01',
              title: 'Member Functionalities',
              items: [
                'Account Management: Log in/Sign up, Reset password, Edit profile',
                'Content Exploration: Browse books & movies, Search content, Watch trailers',
                'Consumption & Interaction: Read books, Watch movies, Like/comment on content'
              ],
            ),
            SizedBox(height: 30),

            // Author Section
            _buildRoleSection(
              number: '02',
              title: 'Author Functionalities',
              items: [
                'Account & Content Management: Upload books, Submit for approval, Edit profile',
                'Exploration & Interaction: Browse content, Read books, Watch movies/trailers',
                'Collaboration: Chat with directors/admins, Create contracts for adaptations'
              ],
            ),
            SizedBox(height: 30),

            // Director Section
            _buildRoleSection(
              number: '03',
              title: 'Director Functionalities',
              items: [
                'Account Management: Secure login, Profile customization',
                'Content Management: Browse books/movies, Search content',
                'Production Tools: Watch movies/read books for inspiration',
                'Collaboration: Chat with authors, Create adaptation contracts'
              ],
            ),

            // Contact Admin Section
            SizedBox(height: 40),
            styleText(
              text: 'Need more information or help?',
              fSize: 19,
              color: textColor2,
            ),
            SizedBox(height: 8),
            styleText(
              text: 'Press the button below to contact our admin team for additional support.',
              fSize: 17,
              color: textColor2,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => message(

                  ));                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: styleText(
                  text: 'Contact Admin',
                  fSize: 19,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSection({required String number, required String title, required List<String> items}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        styleText(
          text: number,
          fSize: 27,
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styleText(
                text: title,
                fSize: 21,
                color: textColor2,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: styleText(
                    text: '• $item',
                    fSize: 17,
                    color: textColor2,
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}