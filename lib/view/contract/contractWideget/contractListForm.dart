import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/variables.dart';
import '../../GlobalWideget/styleText.dart';

class ContractListForm extends StatelessWidget {
  const ContractListForm({
    super.key,
    required this.bookTitle,
    required this.authorName,
    required this.status,
    required this.image,
    required this.onTap,
    this.senderName,
    this.price,
    this.royalty,
  });

  final String bookTitle;
  final String authorName;
  final String status;
  final String image;
  final VoidCallback onTap;
  final String? senderName;
  final dynamic price;
  final dynamic royalty;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return mainColor2!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: blackColor2,
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 100,
                    constraints: const BoxConstraints(
                      minHeight: 150,
                      maxHeight: 200,
                    ),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.book, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      styleText(
                        text: bookTitle,
                        fSize: 22,
                        color: textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      if (senderName != null)
                        styleText(
                          text: "From: $senderName",
                          fSize: 16,
                          color: mainColor2!,
                        ),
                      const SizedBox(height: 4),
                      styleText(
                        text: "By $authorName",
                        fSize: 16,
                        color: mainColor2!,
                      ),
                      if (price != null || royalty != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (price != null)
                              styleText(
                                text: "Price: \$$price",
                                fSize: 14,
                                color: textColor2,
                              ),
                            if (price != null && royalty != null)
                              const SizedBox(width: 16),
                            if (royalty != null)
                              styleText(
                                text: "Royalty: ${royalty}%",
                                fSize: 14,
                                color: textColor2,
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(status),
                            width: 1,
                          ),
                        ),
                        child: styleText(
                          text: status.toUpperCase(),
                          fSize: 14,
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.bold,
                        ),
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