import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/variables.dart';

class homeBottomNav extends StatelessWidget {
  const homeBottomNav({
    super.key, required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: index,
        selectedFontSize: 20,
        unselectedFontSize: 15,
        selectedItemColor: secondaryColor,
        unselectedItemColor: textColor2,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(
          size: 40,
          color: secondaryColor,
        ),
        unselectedIconTheme: IconThemeData(size: 30, color: textColor2),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 40,
              ),
              label: "Home",
              backgroundColor: mainColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                size: 40,
              ),
              label: "Books",
              backgroundColor: mainColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.movie,
                size: 40,
              ),
              label: "Movies",
              backgroundColor: mainColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Message",
              backgroundColor: mainColor)
        ],
      onTap: (val){
        if(val == 0){
          Get.offAllNamed("/homePage");
        }else if(val ==1){
          Get.offAllNamed("/booksCategories");
        }
        else if(val ==2){
          Get.offAllNamed("/moviesCategories");
        }
        else if(val ==3){
          Get.offAllNamed("/ChatPage");
        }
      },
    );
  }
}

