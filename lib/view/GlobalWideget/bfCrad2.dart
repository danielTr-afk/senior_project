import 'package:flutter/material.dart';
import '../../controller/variables.dart';

class bfCard2 extends StatelessWidget {
  const bfCard2({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        height: 300,
        width: 200,
        child: Flexible(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ));
  }
}
