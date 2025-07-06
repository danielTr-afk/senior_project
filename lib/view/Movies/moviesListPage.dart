
import 'package:flutter/material.dart';
import '../../controller/lists/moviesList.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/listForm.dart';
import '../GlobalWideget/styleText.dart';
import '../HomePage/homeWideGet/homeDrawer.dart';

class moviesListPage extends StatelessWidget {
  const moviesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: styleText(
          text: "Books",
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
        actions: [
          IconButton(
              color: textColor2,
              onPressed: () {
                showSearch(context: context, delegate: moviesSearchDelegate());
              },
              icon: Icon(Icons.search))
        ],
      ),
      drawer: homeDrawer(),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            listForm(
                title: "Movie 1",
                subtitle: "Movie of the year",
                nav: "nav",
                image: "images/onBoardingImage/onboardingphoto3.png", numLike: '',),
            listForm(
                title: "Movie 2",
                subtitle: "Movie of the year",
                nav: "nav",
                image: "images/onBoardingImage/onboardingphoto3.png", numLike: '',),
            listForm(
                title: "Movie 3",
                subtitle: "Movie of the year",
                nav: "nav",
                image: "images/onBoardingImage/onboardingphoto3.png", numLike: '',),
          ],
        ),
      ),
    );
  }
}

