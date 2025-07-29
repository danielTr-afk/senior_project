import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController/loginGetX.dart';
import '../../controller/books/booksController.dart';
import '../../controller/movies/moviesController.dart'; // Add this import
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import '../Books/BookDetails/BookDetailsPage.dart'; // Add this import
import '../Movies/MovieDetails/MovieDetailsPage.dart'; // Add this import
import 'homeWideGet/DrawerRole.dart';
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
        drawer: getRoleBasedDrawer(),
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
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailsPage(
                                          filmId: movie['id'].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 180,
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 5, color: mainColor!),
                                      color: textColor2,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                          child: SizedBox(
                                            height: 200,
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              imageUrl: movie['image'] ?? "images/onBoardingImage/onboardingphoto2.png",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                color: Colors.grey[800],
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: Colors.grey[300],
                                                child: Center(
                                                  child: Icon(
                                                    Icons.movie,
                                                    size: 50,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: SizedBox(
                                            height: 85,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: styleText(
                                                    text: movie['title'] ?? "Unknown Title",
                                                    fSize: 16,
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Flexible(
                                                  child: styleText(
                                                    text: "Dir: ${movie['director']?.isNotEmpty == true ? movie['director'] : 'Unknown'}",
                                                    fSize: 14,
                                                    color: mainColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailsPage(
                                          bookId: book['id'].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 180,
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 5, color: textColor2!),
                                      color: mainColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                          child: SizedBox(
                                            height: 200,
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              imageUrl: book['image'],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                color: Colors.grey[800],
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: Colors.grey[300],
                                                child: Center(
                                                  child: Icon(
                                                    Icons.book,
                                                    size: 50,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: SizedBox(
                                            height: 85,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: styleText(
                                                    text: book['title'],
                                                    fSize: 16,
                                                    color: textColor2,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Flexible(
                                                  child: styleText(
                                                    text: "By ${book['author_name']?.isNotEmpty == true ? book['author_name'] : 'Unknown'}",
                                                    fSize: 14,
                                                    color: textColor2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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