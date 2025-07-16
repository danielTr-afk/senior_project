import 'package:flutter/material.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const SettingsTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: secondaryColor),
      title: styleText(text: title, fSize: 20, color: textColor2),
      onTap: () {},
    );
  }
}
