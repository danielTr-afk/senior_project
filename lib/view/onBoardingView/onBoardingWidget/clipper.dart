import 'package:flutter/material.dart';

class CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8); // Start from bottom left

    // Create curved effect
    path.quadraticBezierTo(
      size.width / 2, size.height + 30, // Control point
      size.width, size.height * 0.8, // End point
    );

    path.lineTo(size.width, 0); // Top right corner
    path.close(); // Complete path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}