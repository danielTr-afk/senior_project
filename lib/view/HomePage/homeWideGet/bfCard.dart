import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GlobalWideget/styleText.dart';

class bfCard extends StatelessWidget {
  final String image;
  final String text;
  final void Function()? onTap;
  final Color borderColor;
  final Color titleColor;
  final Color coverColor;
  final Color descriptionColor;
  final bool isBook;
  final String routePage;
  late final String description;

  bfCard({
    super.key,
    required this.image,
    required this.text,
    required this.onTap,
    required this.borderColor,
    required this.titleColor,
    required this.coverColor,
    required String description,
    required this.descriptionColor,
    required this.isBook,
    required this.routePage,
  }) {
    // Manually set the actual field
    this.description = isBook ? "Written by $description" : "Inspired by $description";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.offAllNamed(routePage);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 10),
          color: coverColor,
        ),
        child: Column(
          children: [
            Image.asset(image, fit: BoxFit.cover, height: 200, width: 150),
            styleText(
              text: text,
              fSize: 20,
              color: titleColor,
              textAlign: TextAlign.center,
            ),
            styleText(
              text: description,
              fSize: 15,
              color: descriptionColor,
            ),
          ],
        ),
      ),
    );
  }
}
