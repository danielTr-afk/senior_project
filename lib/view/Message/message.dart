import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:f_book2/view/Message/messageWideget/ChatInputField.dart';
import 'package:flutter/material.dart';

class message extends StatelessWidget {
  final List<Message> messages = [
    Message("Hello, How are you?", true),
    Message("Hey, Bruce! It's been awhile", false),
    Message("What’s up?", false),
    Message("I wonder if you would like to watch movie tonight?", true),
    Message("Sounds like a good idea!", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        leading: Icon(Icons.arrow_back_ios, color: textColor2),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                styleText(text: 'Kathy Gomez', fSize: 25, color: textColor2,),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment:
                  message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: message.isMe ? Color(0xfff0582d) : Color(0xFF2C2C2E),
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
                        Text(
                          message.text,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "4:09 pm",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ChatInputField(),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  Message(this.text, this.isMe);
}

