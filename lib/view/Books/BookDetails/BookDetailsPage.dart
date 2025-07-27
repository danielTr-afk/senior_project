import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: blackColor2,
      appBar: AppBar(
        backgroundColor: blackColor2,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor2),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: styleText(text: 'Book Details', fSize: 30, color: textColor2, fontWeight: FontWeight.bold, ),
        
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: textColor2),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network("https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1566425108l/33._SY475_.jpg"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      styleText(text: "Rombak Pola Pikir", fSize: 22, fontWeight: FontWeight.bold, color: textColor2),
                      const SizedBox(height: 8),
                      styleText(text: "by Iosi Pratama", fSize: 16, color: mainColor2!),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) => Icon(Icons.star, color: index < 4 ? Colors.orange : Colors.grey, size: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _button(Icons.favorite_border, "Like", color: textColor2),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _button(Icons.comment, "Comment"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            styleText(text: "About the book", fSize: 22, color: textColor2, fontWeight: FontWeight.bold,),
            const SizedBox(height: 10),

            styleText(text: "From the founders of 37signals, this book explores a new business reality where tools are accessible and opportunities endless...", fSize: 18, color: mainColor2!),

            const SizedBox(height: 20),

            styleText(text: "Community Reviews", fSize: 20, color: textColor2),
            const SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://via.placeholder.com/40'),
                    radius: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styleText(text: "Iosi Pratama", fSize: 18, color: textColor2, fontWeight: FontWeight.bold,),
                        const SizedBox(height: 4),
                        styleText(text: "Great book for beginners, really shifts your mindset.", fSize: 15, color: mainColor2!)
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // space for button
          ],
        ),
      ),

      floatingActionButton: Container(
        width: screenWidth - 32,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          label: styleText(text: "Read Now", fSize: 20, color: textColor2, fontWeight: FontWeight.bold,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  Widget _button(IconData icon, String text, {Color color = Colors.white}) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        foregroundColor: color,
      ),
      onPressed: () {},
      icon: Icon(icon, size: 18, color: textColor2,),
      label: styleText(text: text, fSize: 18, color: textColor2),
    );
  }
}
