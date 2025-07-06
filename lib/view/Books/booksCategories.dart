import 'package:flutter/material.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/bfCrad2.dart';
import '../GlobalWideget/styleText.dart';
import '../HomePage/homeWideGet/homeBottomNav.dart';
import '../HomePage/homeWideGet/homeDrawer.dart';
import '../HomePage/homeWideGet/titleSection.dart';

class booksCategories extends StatelessWidget {
  const booksCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: styleText(
          text: "Books Categories",
          fSize: 30,
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: mainColor,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.list, size: 30, color: textColor2),
          ),
        ),
      ),
      drawer: homeDrawer(),
      bottomNavigationBar: homeBottomNav(index: 1,),
      body: Container(
        padding: EdgeInsets.all(15),
        color: mainColor3,
        child: ListView(
          children: [
            titleSection(text: "Action", onTap: "/booksListPage", color: mainColor),
            SizedBox(
              height: 315,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  bfCard2(image: 'images/booksImage/actionBook.jpg',),
                  bfCard2(image: 'images/booksImage/actionBook.jpg',),
                  bfCard2(image: 'images/booksImage/actionBook.jpg',),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }
}

