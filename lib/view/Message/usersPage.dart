import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/controller/message/ChatController.dart';
import 'package:f_book2/view/HomePage/homeWideGet/homeBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController/loginGetX.dart';
import '../../controller/message/usersController.dart';

class usersPage extends StatelessWidget {
  usersPage({super.key});

  final usersController UsersController = Get.put(usersController());
  final ChatController chatController = Get.find<ChatController>();
  final loginController = Get.find<loginGetx>();


  void _showStartConversationDialog(Map<String, dynamic> user) {
    final TextEditingController messageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: mainColor,
        title: Text(
          'Start Conversation',
          style: TextStyle(color: textColor2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message to ${user['name']}',
              style: TextStyle(color: mainColor2),
            ),
            SizedBox(height: 16),
            TextField(
              controller: messageController,
              style: TextStyle(color: textColor2),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: mainColor2),
                filled: true,
                fillColor: blackColor2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: mainColor2),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (messageController.text.trim().isNotEmpty) {
                Get.back(); // Close dialog

                // Show loading
                Get.dialog(
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    ),
                  ),
                  barrierDismissible: false,
                );

                // Start conversation
                final success = await chatController.startNewConversation(
                  user['id'],
                  messageController.text.trim(),
                );

                Get.back(); // Close loading dialog

                if (success) {
                  Get.snackbar(
                    'Success',
                    'Conversation started with ${user['name']}',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  Get.back(); // Go back to chat page
                } else {
                  Get.snackbar(
                    'Error',
                    'Failed to start conversation',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              } else {
                Get.snackbar(
                  'Error',
                  'Please enter a message',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
            ),
            child: Text(
              'Send',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor2,
      appBar: AppBar(
        leadingWidth: 110,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: textColor2),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Obx(() => CircleAvatar(
                backgroundImage: NetworkImage(loginController.profileImage.value),
                radius: 30,
              )),
            ),
          ],
        ),
        title: Text("Start New Conversation",
            style: TextStyle(fontSize: 24, color: textColor2)),
        backgroundColor: blackColor2,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextFormField(
              controller: UsersController.searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: mainColor2),
                prefixIcon: Icon(Icons.search, color: secondaryColor),
                filled: true,
                fillColor: mainColor,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Content Area
          Expanded(
            child: Obx(() {
              // Show loading indicator
              if (UsersController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                );
              }

              return ListView.builder(
                itemCount: UsersController.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = UsersController.filteredUsers[index];
                  return Card(
                    color: mainColor,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: secondaryColor,
                        child: Text(
                          user['name'] != null && user['name'].toString().isNotEmpty
                              ? user['name'].toString()[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user['name'] ?? 'Unknown User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor2,
                        ),
                      ),
                      subtitle: Text(
                        user['email'] ?? '',
                        style: TextStyle(
                          color: mainColor2,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(
                        Icons.message,
                        color: secondaryColor,
                      ),
                      onTap: () {
                        _showStartConversationDialog(user);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: homeBottomNav(index: 3),
    );
  }
}