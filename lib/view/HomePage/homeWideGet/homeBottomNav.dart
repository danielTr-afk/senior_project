import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/variables.dart';

class homeBottomNav extends StatelessWidget {
  const homeBottomNav({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mainColor, // Ensure container matches bar color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: index,
          elevation: 0, // Remove default elevation to prevent white artifacts
          type: BottomNavigationBarType.fixed,
          backgroundColor: mainColor,
          unselectedFontSize: 12,
          selectedFontSize: 12,
          selectedItemColor: secondaryColor,
          unselectedItemColor: textColor2.withOpacity(0.7),
          showUnselectedLabels: true,
          selectedIconTheme: IconThemeData(
            color: secondaryColor,
            size: 28,
          ),
          unselectedIconTheme: IconThemeData(
            color: textColor2.withOpacity(0.7),
            size: 26,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.home_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.home),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.menu_book_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.menu_book),
              ),
              label: "Books",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.movie_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.movie),
              ),
              label: "Movies",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.chat_bubble_outline),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Icon(Icons.chat_bubble),
              ),
              label: "Chat",
            ),
          ],
          onTap: (val) {
            if (val == 0) {
              Get.offAllNamed("/homePage");
            } else if (val == 1) {
              Get.offAllNamed("/booksCategories");
            } else if (val == 2) {
              Get.offAllNamed("/moviesCategories");
            } else if (val == 3) {
              Get.offAllNamed("/ChatPage");
            }
          },
        ),
      ),
    );
  }
}