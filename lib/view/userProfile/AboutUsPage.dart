import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';


class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: styleText(
          text: 'About BookFlix',
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
              text: 'Where Movies Meet Books – Unlimited Entertainment',
              fSize: 27,
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20),
            styleText(
              text: 'BookFlix was created to unify entertainment, offering a single subscription for movies, shows, and e-books with smart recommendations linking books to their adaptations.',
              fSize: 19,
              color: textColor2,
            ),
            SizedBox(height: 40),
            _buildSection(
              number: '01',
              title: 'Bridging Literature and Cinema',
              content:
              'We solve the fragmented entertainment landscape by combining streaming and reading in one seamless experience. Whether you want to watch a blockbuster film, read its original novel, or discover new stories across both formats, BookFlix makes it effortless.',
            ),
            SizedBox(height: 30),
            _buildSection(
              number: '02',
              title: 'Community-Focused Experience',
              content:
              'Traditional platforms keep movies and books siloed. BookFlix offers community discussions where fans can compare screen and page versions, creating a more engaging experience for all entertainment lovers.',
            ),
            SizedBox(height: 30),
            _buildSection(
              number: '03',
              title: 'Built with Modern Technology',
              content:
              'Our platform is developed using Flutter for a beautiful cross-platform experience, with PHP and MySQL powering our backend services to ensure reliable performance and data management.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String number, required String title, required String content}) {
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
              styleText(
                text: content,
                fSize: 17,
                color: textColor2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}