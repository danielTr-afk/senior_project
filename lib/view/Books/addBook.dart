import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';

class addBook extends StatelessWidget {
  const addBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: styleText(
          text: "Add New Book",
          fSize: 30,
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Book Name'),
            _buildTextField('Enter book title'),

            const SizedBox(height: 16),
            _buildLabel('Category'),
            _buildDropdown(),

            const SizedBox(height: 16),
            _buildLabel('Description'),
            _buildTextField('Write a short description', maxLines: 4),

            const SizedBox(height: 16),
            _buildLabel('Book Cover Image'),
            _buildPlaceholderButton('Choose Image'),

            const SizedBox(height: 16),
            _buildLabel('Book PDF'),
            _buildPlaceholderButton('Choose PDF'),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: styleText(
                  text: "Submit Book",
                  fSize: 25,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: styleText(text: text, fSize: 25, color: textColor2),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(color: textColor2),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: mainColor2),
        filled: true,
        fillColor: blackColor2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondaryColor!, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: mainColor2!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: null,
          dropdownColor: const Color(0xFF2C2C2C),
          iconEnabledColor: Colors.white,
          hint: styleText(text: "Select category", fSize: 20, color: mainColor2!),
          items: [
            DropdownMenuItem(value: 'Fantasy', child: styleText(text: "Fantasy", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Classic', child: styleText(text: "Classic", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Sci-Fi', child: styleText(text: "Sci-Fi", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Drama', child: styleText(text: "Drama", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Romance', child: styleText(text: "Romance", fSize: 20, color: mainColor2!)),
          ],
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _buildPlaceholderButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.upload_file, color: secondaryColor),
        label: styleText(text: text, fSize: 20, color: textColor2),
        onPressed: () {
          // Placeholder: Would open file/image picker if implemented in StatefulWidget
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: blackColor2,
          foregroundColor: textColor2,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}