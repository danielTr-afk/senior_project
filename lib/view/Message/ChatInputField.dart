import 'package:flutter/material.dart';

import '../../controller/variables.dart';

class ChatInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: blackColor2,
            borderRadius: BorderRadius.circular(30),
          ), child: TextFormField(
          style: TextStyle(color: textColor2),
          decoration: InputDecoration(
            hintText: "Type a message",
            hintStyle: TextStyle(color: mainColor2),
            border: InputBorder.none,
          ),
        ),

        ),
      ),
    );
  }
}
