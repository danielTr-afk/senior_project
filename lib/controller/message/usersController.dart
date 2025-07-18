import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class usersController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var filteredUsers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    searchController.addListener(() => filterUsers(searchController.text));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/get_users.php'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          users.value = List<Map<String, dynamic>>.from(data['users']);
          filteredUsers.value = users;
          print('Users loaded: ${users.length}');
        } else {
          errorMessage.value = data['message'] ?? 'Failed to load users';
          print('Error from server: ${data['message']}');
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      print("Error fetching users: $e");
    }

    isLoading.value = false;
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users
          .where((user) =>
      user['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
          user['email'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void refreshUsers() {
    fetchUsers();
  }
}