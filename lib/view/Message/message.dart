import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/controller/message/MessageController.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MessageController messageController = Get.put(MessageController());
    final Map<String, dynamic> conversation = Get.arguments ?? {};

    // Initialize conversation data
    if (conversation.isNotEmpty) {
      messageController.initializeConversation(conversation);
    }

    final partner = conversation['partner'] ?? {};
    final partnerName = partner['name'] ?? 'Unknown User';

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor2),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: secondaryColor,
              child: Text(
                partnerName.isNotEmpty ? partnerName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  styleText(
                    text: partnerName,
                    fSize: 18,
                    color: textColor2,
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (messageController.isLoading.value &&
                  messageController.messages.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                );
              }

              if (messageController.messages.isEmpty) {
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
                        'No messages yet',
                        style: TextStyle(
                          color: mainColor2,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start the conversation by sending a message',
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
                controller: messageController.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messageController.messages.length,
                itemBuilder: (context, index) {
                  final message = messageController.messages[index];
                  return Align(
                    alignment: message.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: message.isMe ? secondaryColor : blackColor2,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!message.isMe && message.senderName != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                message.senderName!,
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          styleText(
                              text: message.text, fSize: 18, color: textColor2),
                          const SizedBox(height: 4),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: styleText(
                                  text: messageController
                                      .formatMessageTime(message.timestamp),
                                  fSize: 13,
                                  color: mainColor2!)),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Custom input field
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: blackColor2,
              border: Border(
                top: BorderSide(color: mainColor2!.withOpacity(0.3), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController.messageController,
                    style: TextStyle(color: textColor2),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: mainColor2),
                      filled: true,
                      fillColor: mainColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                    minLines: 1,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        messageController.sendMessage();
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Obx(() => GestureDetector(
                      onTap: messageController.isSending.value
                          ? null
                          : messageController.sendMessage,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: messageController.isSending.value
                              ? Colors.grey
                              : secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: messageController.isSending.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      textColor2),
                                ),
                              )
                            : Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
