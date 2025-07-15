import 'package:flutter/material.dart';

import '../../../controller/variables.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: secondaryColor),
        title: Text(title, style: TextStyle(color: textColor2),),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textColor2,),
        tileColor: mainColor,
        onTap: () {
          // Navigation logic here if needed
        },
      ),
    );
  }
}
