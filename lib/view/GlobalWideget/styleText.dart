import 'package:flutter/material.dart';

class styleText extends StatelessWidget {
  const styleText({
    super.key,
    required this.text,
    required this.fSize,
    required this.color,
    this.textAlign, this.fontWeight,
  });

  final String text;
  final double fSize;
  final Color color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontFamily: "GentiumBookPlus",
            fontSize: fSize,
            color: color,
            fontWeight: fontWeight));
  }
}
