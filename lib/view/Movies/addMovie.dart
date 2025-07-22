import 'dart:io';
import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/movies/addMovieController.dart';

class addMovie extends StatelessWidget {
  addMovie({super.key});

  final addMovieController movieController = Get.put(addMovieController());

  // Add TextEditingControllers to properly manage text input
  final TextEditingController movieNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: styleText(
          text: "Add New Movie",
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
            _buildLabel('Movie Name'),
            _buildTextField(
              'Enter movie title',
              controller: movieNameController,
              onChanged: (value) => movieController.movieName.value = value,
            ),

            const SizedBox(height: 16),
            _buildLabel('Category'),
            _buildDropdown(),

            const SizedBox(height: 16),
            _buildLabel('Description'),
            _buildTextField(
              'Write a short description',
              controller: descriptionController,
              maxLines: 4,
              onChanged: (value) => movieController.description.value = value,
            ),

            const SizedBox(height: 16),
            _buildLabel('Movie Cover Image'),
            _buildFilePickerButton(
              'Choose Image',
              isImage: true,
              file: movieController.coverImage, text: 'Choose Image',
            ),

            const SizedBox(height: 16),
            _buildLabel('Trailer'),
            _buildFilePickerButton(
              'Choose Trailer File',
              isVideo: true,
              file: movieController.trailerFile, text: 'Choose Trailer File',
            ),

            const SizedBox(height: 16),
            _buildLabel('Full Movie File'),
            _buildFilePickerButton(
              'Choose Movie File',
              isVideo: true,
              file: movieController.movieFile, text: 'Choose Movie File',
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: movieController.isLoading.value
                    ? null
                    : () => movieController.submitMovie(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: movieController.isLoading.value
                    ? CircularProgressIndicator(color: textColor2)
                    : styleText(
                  text: "Submit Movie",
                  fSize: 25,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Debug section - remove this in production
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  styleText(text: "Debug Info:", fSize: 16, color: Colors.red),
                  Text("Movie Name: '${movieController.movieName.value}'", style: TextStyle(color: Colors.white)),
                  Text("Category: '${movieController.selectedCategory.value}'", style: TextStyle(color: Colors.white)),
                  Text("Description: '${movieController.description.value}'", style: TextStyle(color: Colors.white)),
                ],
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

  Widget _buildTextField(String hint, {
    int maxLines = 1,
    required Function(String value) onChanged,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor2),
      onChanged: onChanged,
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
          isExpanded: true,
          value: movieController.selectedCategory.value.isEmpty
              ? null
              : movieController.selectedCategory.value,
          hint: styleText(text: "Select category", fSize: 20, color: mainColor2!),
          items: [
            'Action', 'Drama', 'Thriller', 'Romance', 'Documentary'
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: styleText(text: value, fSize: 20, color: mainColor2!),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              movieController.setCategory(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilePickerButton(String s, {
    required String text,
    bool isImage = false,
    bool isVideo = false,
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
                movieController.coverImage = File(pickedFile.path);
                movieController.update();
              }
            } else if (isVideo) {
              // Try using FileType.video first
              FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                type: FileType.video,
                allowMultiple: false,
              );

              // If that doesn't work, fallback to any file type
              if (pickedFile == null) {
                pickedFile = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                  allowMultiple: false,
                );
              }

              if (pickedFile != null && pickedFile.files.single.path != null) {
                final filePath = pickedFile.files.single.path!;
                final fileName = pickedFile.files.single.name.toLowerCase();

                // Check if it's a video file
                if (fileName.endsWith('.mp4') ||
                    fileName.endsWith('.mov') ||
                    fileName.endsWith('.avi') ||
                    fileName.endsWith('.mkv')) {

                  if (text.contains('Trailer')) {
                    movieController.trailerFile = File(filePath);
                  } else {
                    movieController.movieFile = File(filePath);
                  }
                  movieController.update();
                  Get.snackbar('Success', 'Video file selected: ${pickedFile.files.single.name}');
                } else {
                  Get.snackbar('Error', 'Please select a valid video file (.mp4, .mov, .avi, .mkv)');
                }
              }
            }
          } catch (e) {
            Get.snackbar('Error', 'Failed to pick file: ${e.toString()}');
            print('File picker error: $e'); // Add this for debugging
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