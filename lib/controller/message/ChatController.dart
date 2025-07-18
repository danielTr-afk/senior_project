import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../authController/loginGetX.dart';

class ChatController extends GetxController {
  final loginController = Get.find<loginGetx>();
  final String baseUrl = 'http://10.0.2.2/BookFlix';

  String get userEmail => loginController.userEmail.value;

  var conversations = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('$baseUrl/get_conversations.php?user_email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Load conversations response: ${response.statusCode}');
      print('Load conversations body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          conversations.value = List<Map<String, dynamic>>.from(data['conversations']);
        } else {
          print('Load conversations failed: ${data['message']}');
        }
      } else {
        print('HTTP Error loading conversations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> startNewConversation(int recipientId, String firstMessage) async {
    try {
      isLoading.value = true;

      // Debug print the data being sent
      final requestData = {
        'sender_email': userEmail,
        'recipient_id': recipientId,
        'message_text': firstMessage,
      };

      print('Starting conversation with data: $requestData');
      print('URL: $baseUrl/start_or_send.php');

      final response = await http.post(
        Uri.parse('$baseUrl/start_or_send.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      );

      print('Start conversation response status: ${response.statusCode}');
      print('Start conversation response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            print('Conversation started successfully');
            await loadConversations(); // Refresh conversations list
            return true;
          } else {
            print('Server returned success=false: ${data['message']}');
            return false;
          }
        } catch (e) {
          print('Error parsing response JSON: $e');
          return false;
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception starting conversation: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String formatTime(String? dateTime) {
    if (dateTime == null) return '';
    try {
      final dt = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(dt);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }
}