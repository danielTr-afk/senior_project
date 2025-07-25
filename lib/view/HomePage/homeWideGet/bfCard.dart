import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GlobalWideget/styleText.dart';

class bfCard extends StatelessWidget {
  final String image;
  final String text;
  final void Function()? onTap;
  final Color borderColor;
  final Color titleColor;
  final Color coverColor;
  final Color descriptionColor;
  final bool isBook;
  final String routePage;
  final String description;

  const bfCard({
    super.key,
    required this.image,
    required this.text,
    required this.onTap,
    required this.borderColor,
    required this.titleColor,
    required this.coverColor,
    required this.description,
    required this.descriptionColor,
    required this.isBook,
    required this.routePage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(routePage),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 5, color: borderColor),
          color: coverColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with fixed height
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: SizedBox(
                height: 200, // Fixed height for image
                width: double.infinity,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        isBook ? Icons.book : Icons.movie,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Content with padding and constrained height
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 85, // Fixed height for text content
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: styleText(
                        text: text,
                        fSize: 16, // Slightly reduced font size
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: styleText(
                        text: isBook
                            ? "By ${description.isNotEmpty ? description : 'Unknown'}"
                            : "Dir: ${description.isNotEmpty ? description : 'Unknown'}",
                        fSize: 14,
                        color: descriptionColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}