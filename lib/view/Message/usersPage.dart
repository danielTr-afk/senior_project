import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/HomePage/homeWideGet/homeBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/message/usersController.dart';

class usersPage extends StatelessWidget {
  usersPage({super.key});

  usersController UsersController = Get.put(usersController());

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
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/1.jpg"),
              ),
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
              controller: UsersController.searchController, // Connected to controller
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

              // Show error message
              if (UsersController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Error loading users',
                        style: TextStyle(
                          color: textColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        UsersController.errorMessage.value,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          UsersController.refreshUsers();
                        },
                        child: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show empty state
              if (UsersController.filteredUsers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: mainColor2,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        UsersController.searchController.text.isEmpty
                            ? 'No users found'
                            : 'No users match your search',
                        style: TextStyle(
                          color: textColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        UsersController.searchController.text.isEmpty
                            ? 'Check your database or network connection'
                            : 'Try a different search term',
                        style: TextStyle(
                          color: mainColor2,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                        Icons.chevron_right,
                        color: secondaryColor,
                      ),
                      onTap: () {
                        // Handle user selection
                        print('Selected user: ${user['name']}');
                        // You can navigate to chat screen here
                        // Get.to(() => ChatScreen(user: user));
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