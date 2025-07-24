import 'dart:io';
import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../controller/movies/addMovieController.dart';

class addMovie extends StatelessWidget {
  addMovie({super.key});

  final addMovieController movieController = Get.put(addMovieController());
  final TextEditingController movieNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: styleText(
          text: "Add New Movie",
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
            _buildLabel('Movie Name'),
            _buildTextField(
              'Enter movie title',
              controller: movieNameController,
              onChanged: (value) => movieController.movieName.value = value,
            ),

            const SizedBox(height: 20),
            _buildLabel('Category'),
            _buildDropdown(),

            const SizedBox(height: 20),
            _buildLabel('Description'),
            _buildTextField(
              'Write a short description',
              controller: descriptionController,
              maxLines: 5,
              onChanged: (value) => movieController.description.value = value,
            ),

            const SizedBox(height: 20),
            _buildLabel('Movie Cover Image'),
            _buildFilePickerButton(
              'Choose Image',
              isImage: true,
              file: movieController.coverImage,
              text: 'Choose Image',
            ),
            if (movieController.coverImage != null) ...[
              const SizedBox(height: 8),
              _buildFileInfo(movieController.coverImage!),
            ],

            const SizedBox(height: 20),
            _buildLabel('Trailer'),
            _buildFilePickerButton(
              'Choose Trailer File',
              isVideo: true,
              file: movieController.trailerFile,
              text: 'Choose Trailer File',
            ),
            if (movieController.trailerFile != null) ...[
              const SizedBox(height: 8),
              _buildFileInfo(movieController.trailerFile!),
            ],

            const SizedBox(height: 20),
            _buildLabel('Full Movie File'),
            _buildFilePickerButton(
              'Choose Movie File',
              isVideo: true,
              file: movieController.movieFile,
              text: 'Choose Movie File',
            ),
            if (movieController.movieFile != null) ...[
              const SizedBox(height: 8),
              _buildFileInfo(movieController.movieFile!),
            ],

            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      )),
    );
  }

  Widget _buildLabel(String text) {
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

  Widget _buildTextField(String hint, {
    int maxLines = 1,
    required Function(String value) onChanged,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor2, fontSize: 16),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: mainColor2!),
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
          value: movieController.selectedCategory.value.isEmpty
              ? null
              : movieController.selectedCategory.value,
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
            'Action', 'Drama', 'Thriller', 'Romance', 'Documentary'
          ].map((String value) {
            return DropdownMenuItem<String>(
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
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                movieController.coverImage = File(pickedFile.path);
                movieController.update();
              }
            } else if (isVideo) {
              FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                type: FileType.video,
                allowMultiple: false,
              );

              if (pickedFile == null) {
                pickedFile = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                  allowMultiple: false,
                );
              }

              if (pickedFile != null && pickedFile.files.single.path != null) {
                final filePath = pickedFile.files.single.path!;
                final fileName = pickedFile.files.single.name.toLowerCase();

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
                } else {
                  Get.snackbar('Error', 'Please select a valid video file (.mp4, .mov, .avi, .mkv)');
                }
              }
            }
          } catch (e) {
            Get.snackbar('Error', 'Failed to pick file: ${e.toString()}');
          }
        },
        child: Row(
          children: [
            Icon(Icons.upload_file, color: secondaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: styleText(
                text: file?.path.split('/').last ?? text,
                fSize: 16,
                color: textColor2,
              ),
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
              if (file == movieController.coverImage) {
                movieController.coverImage = null;
              } else if (file == movieController.trailerFile) {
                movieController.trailerFile = null;
              } else {
                movieController.movieFile = null;
              }
              movieController.update();
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
        onPressed: movieController.isLoading.value
            ? null
            : () => movieController.submitMovie(),
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: movieController.isLoading.value
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          ),
        )
            : styleText(
          text: "Submit Movie",
          fSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}