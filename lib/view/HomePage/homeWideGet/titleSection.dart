import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class titleSection extends StatelessWidget {
  const titleSection({
    super.key,
    required this.text,
    required this.onTap, required this.color,
  });

  final String text;
  final String onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              styleText(text: text, fSize: 30, color: color),
              InkWell(
                  onTap: () {
                    Get.toNamed(onTap);
                  },
                  child: styleText(
                      text: "see all", fSize: 15, color: secondaryColor))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
