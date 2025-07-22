import 'dart:io';

import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../controller/authController/loginGetX.dart';
import '../../controller/books/addBookController.dart';

class addBook extends StatelessWidget {
  addBook({super.key});

  final addBookController bookController = Get.put(addBookController());
  final loginGetx authController = Get.find<loginGetx>();

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
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: textColor2),
        ),
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Book Name'),
            _buildTextField(
              'Enter book title',
              controller: TextEditingController(text: bookController.bookName.value),
              onChanged: (value) => bookController.bookName.value = value, hint: 'Enter book title',
            ),

            const SizedBox(height: 16),
            _buildLabel('Category'),
            _buildDropdown(),

            const SizedBox(height: 16),
            _buildLabel('Description'),
            _buildTextField(
              'Write a short description',
              maxLines: 4,
              controller: TextEditingController(text: bookController.description.value),
              onChanged: (value) => bookController.description.value = value, hint: 'Write a short description',
            ),

            const SizedBox(height: 16),
            _buildLabel('Book Cover Image'),
            _buildFilePickerButton(
              'Choose Image',
              isImage: true,
              file: bookController.coverImage, text: 'Choose Image',
            ),

            const SizedBox(height: 16),
            _buildLabel('Book PDF'),
            _buildFilePickerButton(
              'Choose PDF',
              isImage: false,
              file: bookController.pdfFile, text: 'Choose PDF',
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: bookController.isLoading.value
                    ? null
                    : () => bookController.submitBook(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: bookController.isLoading.value
                    ? CircularProgressIndicator(color: textColor2)
                    : styleText(
                  text: "Submit Book",
                  fSize: 25,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: styleText(text: text, fSize: 25, color: textColor2),
    );
  }

  Widget _buildTextField(String s, {
    required String hint,
    int maxLines = 1,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
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
      onChanged: onChanged,
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
          value: bookController.selectedCategory.value.isEmpty
              ? null
              : bookController.selectedCategory.value,
          dropdownColor: const Color(0xFF2C2C2C),
          iconEnabledColor: Colors.white,
          hint: styleText(text: "Select category", fSize: 20, color: mainColor2!),
          items: [
            DropdownMenuItem(value: 'Fantasy', child: styleText(text: "Fantasy", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Classic', child: styleText(text: "Classic", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Science Fiction', child: styleText(text: "Science Fiction", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Drama', child: styleText(text: "Drama", fSize: 20, color: mainColor2!)),
            DropdownMenuItem(value: 'Romance', child: styleText(text: "Romance", fSize: 20, color: mainColor2!)),
          ],
          onChanged: (value) {
            if (value != null) {
              bookController.setCategory(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilePickerButton(String s, {
    required String text,
    required bool isImage,
    required File? file,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.upload_file, color: secondaryColor),
        label: styleText(
          text: file?.path.split('/').last ?? text,
          fSize: 20,
          color: textColor2,
        ),
        onPressed: () async {
          try {
            if (isImage) {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                bookController.coverImage = File(pickedFile.path);
                bookController.update();
              }
            } else {
              final pickedFile = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              if (pickedFile != null && pickedFile.files.single.path != null) {
                bookController.pdfFile = File(pickedFile.files.single.path!);
                bookController.update();
              }
            }
          } catch (e) {
            Get.snackbar('Error', 'Failed to pick file: ${e.toString()}');
          }
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