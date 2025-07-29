import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import '../../../controller/authController/loginGetX.dart';
import '../../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';

class AuthorDrawer extends StatelessWidget {
  AuthorDrawer({super.key});

  final loginController = Get.find<loginGetx>();
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadImage(File imageFile) async {
    try {
      var uri = Uri.parse("http://10.0.2.2/BookFlix/upload_profile_image.php");
      var request = http.MultipartRequest('POST', uri);

      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'profile_image',
        stream,
        length,
        filename: basename(imageFile.path),
      );

      request.files.add(multipartFile);
      request.fields['user_id'] = loginController.userId.value.toString();

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      final result = json.decode(respStr);

      if (response.statusCode == 200 && result['success'] == true) {
        loginController.updateProfileImage(result['image_url']);
        Get.snackbar('Success', 'Profile image updated',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error', result['message'] ?? 'Upload failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _uploadImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      height: 1,
      color: secondaryColor.withOpacity(0.2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 24),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: secondaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: secondaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: loginController.profileImage.value.isNotEmpty
                        ? NetworkImage(loginController.profileImage.value)
                        : const NetworkImage("https://randomuser.me/api/portraits/men/1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: secondaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.camera_alt,
                      size: 24,
                      color: secondaryColor),
                  onPressed: _pickImage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          styleText(
            text: loginController.userName.value,
            fSize: 22,  // Adjusted size
            color: textColor2,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          styleText(
            text: loginController.userEmail.value,
            fSize: 16,  // Adjusted size
            color: textColor2.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,  // Slightly wider
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(40)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(40)),
        ),
        child: Obx(() {
          return Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8),
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      text: "Profile",
                      onTap: '/ProfilePage',
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      text: "Settings",
                      onTap: '/settingsPage',
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.book_outlined,
                      text: "Upload Book",
                      onTap: '/addBook',
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.assignment_outlined,
                      text: "Create Contract",
                      onTap: '/createContract',
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.assignment_ind_outlined,
                      text: "Contracts",
                      onTap: '/contractsListPage',
                    ),
                    _buildDivider(),
                    const Spacer(),
                    _buildMenuItem(
                      icon: Icons.exit_to_app_outlined,
                      text: "Logout",
                      onTap: '/login',
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required String onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),  // Increased vertical padding
      leading: Icon(
        icon,
        size: 26,
        color: secondaryColor,
      ),
      title: styleText(
        text: text,
        fSize: 17,
        color: textColor2,
        fontWeight: FontWeight.normal,
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 22,
        color: secondaryColor.withOpacity(0.5),
      ),
      onTap: () => Get.toNamed(onTap),
    );
  }
}