import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String ontap;
  const SettingsTile({super.key, required this.icon, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: secondaryColor),
      title: styleText(text: title, fSize: 20, color: textColor2),
      onTap: () {
        Get.toNamed(ontap);
      },
    );
  }
}
