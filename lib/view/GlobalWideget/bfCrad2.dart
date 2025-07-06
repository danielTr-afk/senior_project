import 'package:flutter/material.dart';
import '../../controller/variables.dart';

class bfCard2 extends StatelessWidget {
  const bfCard2({
    super.key, required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        height: 300,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border(
                bottom: BorderSide(color: textColor2, width: 8),
                right: BorderSide(color: textColor2, width: 15),
            )
        ),
        child: Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(20)
            ),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        )
    );
  }
}
