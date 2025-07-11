import 'package:flutter/material.dart';

import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class circularWidget extends StatelessWidget {
  const circularWidget({
    super.key, required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.34,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
            child: styleText(
              text: text,
              fSize: 80,
              color: secondaryColor,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}