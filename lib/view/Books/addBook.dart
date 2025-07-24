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
        elevation: 0,
        title: styleText(
          text: "Add New Book",
          fSize: 24,
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: textColor2),
        ),
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Name Field
            _buildSectionTitle('Book Title'),
            _buildTextField(
              hint: 'Enter book title',
              controller: bookController.bookNameController,
              icon: Icons.title,
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            _buildSectionTitle('Category'),
            _buildDropdown(),
            const SizedBox(height: 20),

            // Description Field
            _buildSectionTitle('Description'),
            _buildTextField(
              hint: 'Write a short description about the book',
              maxLines: 5,
              controller: bookController.descriptionController,
              icon: Icons.description,
            ),
            const SizedBox(height: 20),

            // Cover Image Picker
            _buildSectionTitle('Book Cover Image'),
            _buildFilePickerButton(
              isImage: true,
              file: bookController.coverImage,
              buttonText: 'Select Cover Image',
              icon: Icons.image,
            ),
            if (bookController.coverImage != null) ...[
              const SizedBox(height: 8),
              _buildFileInfo(bookController.coverImage!),
            ],
            const SizedBox(height: 20),

            // PDF Picker
            _buildSectionTitle('Book PDF File'),
            _buildFilePickerButton(
              isImage: false,
              file: bookController.pdfFile,
              buttonText: 'Select PDF File',
              icon: Icons.picture_as_pdf,
            ),
            if (bookController.pdfFile != null) ...[
              const SizedBox(height: 8),
              _buildFileInfo(bookController.pdfFile!),
            ],
            const SizedBox(height: 30),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      )),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: styleText(
        text: text,
        fSize: 18,
        color: textColor2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      style: TextStyle(color: textColor2, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: mainColor2!),
        prefixIcon: Icon(icon, color: secondaryColor),
        filled: true,
        fillColor: blackColor2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: blackColor2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: bookController.selectedCategory.value.isEmpty
              ? null
              : bookController.selectedCategory.value,
          dropdownColor: blackColor2,
          icon: Icon(Icons.arrow_drop_down, color: secondaryColor),
          iconSize: 28,
          hint: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: styleText(
              text: "Select category",
              fSize: 16,
              color: mainColor2!,
            ),
          ),
          items: [
            _buildDropdownItem('Fantasy'),
            _buildDropdownItem('Classic'),
            _buildDropdownItem('Science Fiction'),
            _buildDropdownItem('Drama'),
            _buildDropdownItem('Romance'),
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

  DropdownMenuItem<String> _buildDropdownItem(String value) {
    return DropdownMenuItem(
      value: value,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: styleText(
          text: value,
          fSize: 16,
          color: textColor2,
        ),
      ),
    );
  }

  Widget _buildFilePickerButton({
    required bool isImage,
    required File? file,
    required String buttonText,
    required IconData icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: blackColor2,
          foregroundColor: textColor2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          try {
            if (isImage) {
              final pickedFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                imageQuality: 80,
              );
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
            Get.snackbar(
              'Error',
              'Failed to pick file: ${e.toString()}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: secondaryColor),
            const SizedBox(width: 10),
            styleText(
              text: file?.path.split('/').last ?? buttonText,
              fSize: 16,
              color: textColor2,

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo(File file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: styleText(
              text: file.path.split('/').last,
              fSize: 14,
              color: Colors.green,
            ),
          ),
          TextButton(
            onPressed: () {
              if (file == bookController.coverImage) {
                bookController.coverImage = null;
              } else {
                bookController.pdfFile = null;
              }
              bookController.update();
            },
            child: styleText(
              text: 'Remove',
              fSize: 14,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: bookController.isLoading.value
            ? null
            : () => bookController.submitBook(),
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: bookController.isLoading.value
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          ),
        )
            : styleText(
          text: "Submit Book",
          fSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}