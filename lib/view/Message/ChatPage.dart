import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/controller/message/ChatController.dart';
import 'package:f_book2/view/HomePage/homeWideGet/homeBottomNav.dart';
import 'package:f_book2/view/Message/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    return Scaffold(
      backgroundColor: blackColor2,
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundImage:
            NetworkImage("https://randomuser.me/api/portraits/men/1.jpg"),
          ),
        ),
        title: Text("Chats", style: TextStyle(fontSize: 24, color: textColor2)),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, size: 30, color: secondaryColor),
            onPressed: () {
              Get.toNamed('/usersPage');
            },
          ),
        ],
        backgroundColor: blackColor2,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
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

          // Chat List
          Expanded(
            child: Obx(() {
              if (chatController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                );
              }

              if (chatController.conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: mainColor2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No conversations yet',
                        style: TextStyle(
                          color: mainColor2,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start a new conversation by tapping the + button',
                        style: TextStyle(
                          color: mainColor2,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: chatController.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = chatController.conversations[index];
                  final partner = conversation['partner'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: secondaryColor,
                      child: Text(
                        partner['name'] != null && partner['name'].toString().isNotEmpty
                            ? partner['name'].toString()[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      partner['name'] ?? 'Unknown User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor2,
                      ),
                    ),
                    subtitle: Text(
                      conversation['last_message'] ?? 'No messages yet',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: mainColor2),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chatController.formatTime(conversation['last_message_time']),
                          style: TextStyle(
                            color: mainColor2,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to message page with conversation data
                      Get.to(() => message(), arguments: conversation);
                    },
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