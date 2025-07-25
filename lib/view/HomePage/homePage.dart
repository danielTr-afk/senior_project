import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController/loginGetX.dart';
import '../../controller/books/booksController.dart';
import '../../controller/movies/moviesController.dart'; // Add this import
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import 'homeWideGet/bfCard.dart';
import 'homeWideGet/homeBottomNav.dart';
import 'homeWideGet/homeDrawer.dart';
import 'homeWideGet/titleSection.dart';

class homePage extends StatelessWidget {
  homePage({super.key});

  final controller = Get.put(BooksController());
  final movieController = Get.put(moviesController());
  final loginController = Get.find<loginGetx>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: homeDrawer(),
        bottomNavigationBar: homeBottomNav(
          index: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(30),
                          height: MediaQuery.of(context).size.height * 0.33,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                mainColor2!,
                                mainColor,
                                mainColor,
                                mainColor,
                                mainColor2!
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Builder(
                                    builder: (context) => IconButton(
                                      onPressed: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                      icon: Icon(Icons.list,
                                          size: 40, color: textColor2),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Obx(() => CircleAvatar(
                                    backgroundImage: NetworkImage(loginController.profileImage.value),
                                    radius: 30,
                                  )),

                                  SizedBox(width: 15),
                                  Obx(() => styleText(
                                    text:
                                    "Welcome Back \n${loginController.userName.value}",
                                    fSize: 18,
                                    color: secondaryColor,
                                  ))
                                ],
                              ),
                              titleSection(
                                text: "Top Books",
                                color: textColor2,
                                onTap: '/booksListPage',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.23),
                        titleSection(
                            text: "Top Movies",
                            onTap: '/moviesListPage',
                            color: mainColor),
                        SizedBox(
                          height: 320,
                          child: Obx(() {
                            if (movieController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (movieController.movies.isEmpty) {
                              return Center(
                                child: styleText(
                                  text: "No movies available",
                                  fSize: 16,
                                  color: mainColor,
                                ),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                var movie = movieController.movies[index];
                                return bfCard(
                                  image: movie['image'] ?? "images/onBoardingImage/onboardingphoto2.png",
                                  text: movie['title'] ?? "Unknown Title",
                                  onTap: () {
                                    // Add navigation to movie detail page if needed
                                  },
                                  borderColor: mainColor,
                                  titleColor: mainColor,
                                  coverColor: textColor2,
                                  isBook: false,
                                  description: movie[''] ?? 'Unknown Category',
                                  descriptionColor: mainColor,
                                  routePage: '',
                                );
                              },
                            );
                          }),
                        ),
                        SizedBox(height: 100),
                        // Leave space above BottomNavigationBar
                      ],
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.2,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 320,
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                var book = controller.books[index];
                                return bfCard(
                                  image: book['image'],
                                  text: book['title'],
                                  onTap: () {},
                                  borderColor: textColor2,
                                  titleColor: textColor2,
                                  coverColor: mainColor,
                                  isBook: true,
                                  description: book['author_name'],
                                  descriptionColor: textColor2,
                                  routePage: '',
                                );
                              },
                            );
                          }),
                        )),
                  ],
                ),
              ),
            );
          },
        ));
  }
}