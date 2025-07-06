import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class homeListTile extends StatelessWidget {
  const homeListTile({
    super.key, required this.icon, required this.text, required this.onTap,
  });

  final IconData icon;
  final String text;
  final String onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            size: 23,
            color: textColor1,
          ),
          title: styleText(text: text, fSize: 23, color: textColor1),
          onTap: () {
            Get.offAllNamed(onTap);
          },
          selectedColor: secondaryColor,
          tileColor: textColor1,
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
