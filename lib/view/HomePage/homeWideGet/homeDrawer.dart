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
import '../../GlobalWideget/styleText.dart';
import 'homeListTile.dart';

class homeDrawer extends StatelessWidget {
  homeDrawer({
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      shadowColor: Colors.black,
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [mainColor, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Obx(() {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      backgroundColor: mainColor,
                      backgroundImage: loginController.profileImage.value.isNotEmpty
                          ? NetworkImage(loginController.profileImage.value)
                          : NetworkImage("https://randomuser.me/api/portraits/men/1.jpg"),
                      radius: MediaQuery.of(context).size.width * 0.25,
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(Icons.photo_camera, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                styleText(
                  text: loginController.userName.value,
                  fSize: 30,
                  color: textColor1,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                styleText(
                  text: loginController.userEmail.value,
                  fSize: 17,
                  color: textColor1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                homeListTile(icon: Icons.person, text: "Profile", onTap: '/ProfilePage'),
                homeListTile(icon: Icons.settings, text: "Settings", onTap: '/settingsPage'),
                homeListTile(
                    icon: Icons.arrow_right_alt,
                    text: "Logout",
                    onTap: '/login')
              ],
            );
          })),
    );
  }
}