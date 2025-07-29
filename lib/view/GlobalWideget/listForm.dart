import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controller/variables.dart';
import 'styleText.dart';

class listForm extends StatelessWidget {
  const listForm({
    super.key,
    required this.title,
    required this.subtitle,
    required this.nav,
    required this.image,
    required this.numLike,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String nav;
  final String image;
  final String numLike;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: blackColor2,
        elevation: 2,
        child: InkWell(
          onTap: onTap ?? () => Get.offAll(nav),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 100,
                    constraints: BoxConstraints(
                      minHeight: 150,
                      maxHeight: 200,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.book, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      styleText(
                        text: title,
                        fSize: 22,
                        color: textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      // Description
                      styleText(
                        text: subtitle,
                        fSize: 18,
                        color: mainColor2!,
                      ),
                      const SizedBox(height: 8),
                      // Likes and Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          styleText(
                            text: '$numLike likes',
                            fSize: 16,
                            color: mainColor2!.withOpacity(0.8),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 28,
                            color: textColor2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}