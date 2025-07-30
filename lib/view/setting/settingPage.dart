import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controller/authController/loginGetX.dart';
import '../../controller/variables.dart';
import 'settingWideget/SettingsTile.dart';

class settingsPage extends StatefulWidget {
  settingsPage({super.key});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  final loginController = Get.find<loginGetx>();

  // Controllers for input fields
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Visibility states
  bool showPhoneField = false;
  bool showPasswordFields = false;

  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: blackColor2,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.35,
              color: secondaryColor,
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios, color: textColor2),
                      ),
                      styleText(
                        text: "Setting",
                        fSize: 30,
                        color: textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                      const Spacer(),
                      Icon(Icons.settings, color: textColor2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Obx(() => CircleAvatar(
                        backgroundImage: NetworkImage(loginController.profileImage.value),
                        radius: 30,
                      )),
                      const SizedBox(width: 10),
                      styleText(
                        text: loginController.userName.value,
                        fSize: 20,
                        color: textColor2,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -140),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor2!,
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.notifications, color: secondaryColor),
                        title: styleText(
                          text: "Notifications",
                          fSize: 20,
                          color: textColor2,
                        ),
                        trailing: Switch(
                          value: notificationsEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              notificationsEnabled = value;
                            });
                            // Here you can add API call to save notification preference if needed
                          },
                          activeColor: secondaryColor,
                          activeTrackColor: secondaryColor.withOpacity(0.5),
                          inactiveThumbColor: Colors.grey[400],
                          inactiveTrackColor: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      const Divider(),
                      // Phone Number Setting
                      ListTile(
                        leading: Icon(Icons.phone, color: secondaryColor),
                        title: styleText(
                          text: "Change phone number",
                          fSize: 20,
                          color: textColor2,
                        ),
                        onTap: () {
                          setState(() {
                            showPhoneField = !showPhoneField;
                          });
                        },
                      ),
                      if (showPhoneField) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  color: textColor2,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter new phone number',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: secondaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showPhoneField = false;
                                        phoneController.clear();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text('Cancel', style: TextStyle(color: Colors.white)),
                                  ),
                                  ElevatedButton(
                                    onPressed: _updatePhoneNumber,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                    ),
                                    child: Text('Update', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Divider(),

                      // Password Setting
                      ListTile(
                        leading: Icon(Icons.password, color: secondaryColor),
                        title: styleText(
                          text: "Change password",
                          fSize: 20,
                          color: textColor2,
                        ),
                        onTap: () {
                          setState(() {
                            showPasswordFields = !showPasswordFields;
                          });
                        },
                      ),
                      if (showPasswordFields) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(
                                  color: textColor2,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter new password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: secondaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                style: TextStyle(
                                  color: textColor2,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Confirm new password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: secondaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showPasswordFields = false;
                                        passwordController.clear();
                                        confirmPasswordController.clear();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text('Cancel', style: TextStyle(color: Colors.white)),
                                  ),
                                  ElevatedButton(
                                    onPressed: _updatePassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                    ),
                                    child: Text('Update', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Divider(),

                      // Logout
                      ListTile(
                        leading: Icon(Icons.logout, color: secondaryColor),
                        title: styleText(
                          text: "Logout",
                          fSize: 20,
                          color: textColor2,
                        ),
                        onTap: () {
                          Get.offAllNamed("/login");
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePhoneNumber() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter phone number');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/update_phone.php'),
        body: {
          'user_id': loginController.userId.toString(),
          'phone': phoneController.text,
        },
      );

      final data = json.decode(response.body);
      if (data['success']) {
        Get.snackbar('Success', 'Phone number updated successfully');
        setState(() {
          showPhoneField = false;
          phoneController.clear();
        });
      } else {
        Get.snackbar('Error', data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed');
    }
  }

  Future<void> _updatePassword() async {
    try {
      // Extract and validate text input
      final String email = loginController.userEmail.value.trim();
      final String newPassword = passwordController.text.trim();
      final String confirmPassword = confirmPasswordController.text.trim();

      if (newPassword.isEmpty || confirmPassword.isEmpty) {
        Get.snackbar('Error', 'Please fill all fields');
        return;
      }

      if (newPassword != confirmPassword) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      if (newPassword.length < 8) {
        Get.snackbar('Error', 'Password must be at least 8 characters');
        return;
      }

      // Build request body
      final Map<String, dynamic> requestBody = {
        'email': email,
        'new_pass': newPassword,
      };

      // Debug print
      print('Sending JSON: ${json.encode(requestBody)}');

      // Make the request
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/update_password_setting.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      // Handle response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        Get.snackbar('Success', 'Password updated successfully');
        setState(() {
          showPasswordFields = false;
          passwordController.clear();
          confirmPasswordController.clear();
        });
      } else {
        Get.snackbar('Error', responseData['message'] ?? 'Failed to update password');
      }
    } catch (e) {
      print('Error during password update: $e');
      Get.snackbar('Error', 'Failed to update password: ${e.toString()}');
    }
  }


  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}