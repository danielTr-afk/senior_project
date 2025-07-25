import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class titleSection extends StatelessWidget {
  const titleSection({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });

  final String text;
  final String onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          styleText(
            text: text,
            fSize: 28,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          InkWell(
            onTap: () => Get.toNamed(onTap),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: secondaryColor, width: 1.5),
              ),
              child: styleText(
                text: "See All",
                fSize: 16,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}