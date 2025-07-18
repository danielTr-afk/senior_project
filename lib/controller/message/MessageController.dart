import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../authController/loginGetX.dart';

class MessageController extends GetxController {
  final loginController = Get.find<loginGetx>();
  final String baseUrl = 'http://10.0.2.2/BookFlix';

  String get userEmail => loginController.userEmail.value;

  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int? conversationId;
  Map<String, dynamic>? conversationData;
  Timer? _messageTimer;

  @override
  void onInit() {
    super.onInit();
    // Auto-refresh messages every 3 seconds
    _messageTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (conversationId != null) {
        loadMessages();
      }
    });
  }

  @override
  void onClose() {
    _messageTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void initializeConversation(Map<String, dynamic> conversation) {
    conversationData = conversation;
    conversationId = conversation['id'];
    loadMessages();
  }

  Future<void> loadMessages() async {
    if (conversationId == null) return;

    try {
      // Add user_email parameter to the request
      final response = await http.get(
        Uri.parse('$baseUrl/get_messages.php?conversation_id=$conversationId&user_email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final messageList = data['messages'] as List;
          messages.value = messageList.map((msg) => Message(
            id: msg['id'],
            text: msg['message_text'],
            isMe: msg['sender_email'] == userEmail,
            timestamp: msg['created_at'],
            senderName: msg['sender_name'],
          )).toList();

          // Auto-scroll to bottom
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        } else {
          print('Error loading messages: ${data['message']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || conversationId == null) return;

    final messageText = messageController.text.trim();
    messageController.clear();

    try {
      isSending.value = true;
      final response = await http.post(
        Uri.parse('$baseUrl/send_message.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_email': userEmail,
          'conversation_id': conversationId,
          'message_text': messageText,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          await loadMessages(); // Refresh messages
        } else {
          print('Error sending message: ${data['message']}');
          // Restore message text on error
          messageController.text = messageText;
        }
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        // Restore message text on error
        messageController.text = messageText;
      }
    } catch (e) {
      print('Error sending message: $e');
      // Restore message text on error
      messageController.text = messageText;
    } finally {
      isSending.value = false;
    }
  }

  String formatMessageTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp);
      final hour = dt.hour;
      final minute = dt.minute;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return '';
    }
  }
}

class Message {
  final int id;
  final String text;
  final bool isMe;
  final String? timestamp;
  final String? senderName;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    this.timestamp,
    this.senderName,
  });
}