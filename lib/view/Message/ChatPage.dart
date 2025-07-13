import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/HomePage/homeWideGet/homeBottomNav.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  final List<Map<String, dynamic>> chats = const [
    {
      "name": "Sara Sanders",
      "message": "Can you buy me dinner?",
      "time": "12:35",
      "unread": "100",
      "avatar": "https://randomuser.me/api/portraits/women/1.jpg"
    },
    {
      "name": "Doris Diaz",
      "message": "Read this article, it is so awesome..",
      "time": "12:35",
      "unread": "99+",
      "avatar": "https://randomuser.me/api/portraits/women/2.jpg"
    },
    {
      "name": "Dorothy Oliver",
      "message": "Where you at? I'm here.",
      "time": "12:35",
      "unread": "3",
      "avatar": "https://randomuser.me/api/portraits/women/3.jpg"
    },
    {
      "name": "Rebecca Fox",
      "message": "What do you need?",
      "time": "12:35",
      "unread": "",
      "avatar": "https://randomuser.me/api/portraits/women/4.jpg"
    },
    {
      "name": "Louisa McCoy",
      "message": "Read this article, it is so sad... awesome..",
      "time": "12:35",
      "unread": "",
      "avatar": "https://randomuser.me/api/portraits/women/5.jpg"
    },
    {
      "name": "Jasmine Freeman",
      "message": "Are you sure?",
      "time": "12:35",
      "unread": "",
      "avatar": "https://randomuser.me/api/portraits/women/6.jpg"
    },
    {
      "name": "Marie Lucas",
      "message": "I know that.",
      "time": "12:35",
      "unread": "",
      "avatar": "https://randomuser.me/api/portraits/women/7.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.add_circle, size: 30, color: Colors.red),
            onPressed: () {},
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
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat['avatar']),
                    radius: 25,
                  ),
                  title: Text(
                    chat['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor2),
                  ),
                  subtitle: Text(
                    chat['message'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: mainColor2),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(chat['time']),
                      if (chat['unread'] != "")
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat['unread'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: homeBottomNav(index: 3),
    );
  }
}