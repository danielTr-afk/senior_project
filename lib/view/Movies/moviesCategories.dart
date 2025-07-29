import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/movies/moviesController.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/bfCrad2.dart';
import '../GlobalWideget/styleText.dart';
import '../HomePage/homeWideGet/DrawerRole.dart';
import '../HomePage/homeWideGet/homeBottomNav.dart';
import '../HomePage/homeWideGet/homeDrawer.dart';
import '../HomePage/homeWideGet/titleSection.dart';
import '../Movies/MovieDetails/MovieDetailsPage.dart';

class moviesCategories extends StatelessWidget {
  const moviesCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesController controller = Get.put(moviesController());

    return Scaffold(
      appBar: AppBar(
        title: styleText(
          text: "Movies Categories",
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
            icon: Icon(Icons.menu, size: 30, color: textColor2),
          ),
        ),
      ),
      drawer: getRoleBasedDrawer(),
      bottomNavigationBar: homeBottomNav(index: 2),
      body: Container(
        color: blackColor2,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  styleText(
                    text: controller.errorMessage.value,
                    fSize: 16,
                    color: textColor2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshMovies(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                    ),
                    child: styleText(
                      text: "Retry",
                      fSize: 16,
                      color: textColor2,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.categorizedMovies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_outlined,
                    size: 64,
                    color: mainColor2,
                  ),
                  const SizedBox(height: 16),
                  styleText(
                    text: "No movies found",
                    fSize: 18,
                    color: textColor2,
                  ),
                  const SizedBox(height: 8),
                  styleText(
                    text: "Pull to refresh",
                    fSize: 14,
                    color: mainColor2!,
                  ),
                ],
              ),
            );
          }

          final categories = controller.categorizedMovies.keys.toList();

          return RefreshIndicator(
            onRefresh: () => controller.refreshMovies(),
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final movies = controller.categorizedMovies[category]!;

                if (movies.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleSection(
                      text: category,
                      onTap: "/moviesListPage",
                      color: textColor2,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, i) {
                          final movie = movies[i];
                          return GestureDetector(
                            onTap: () {
                              if (movie['id'] != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsPage(
                                      filmId: movie['id'].toString(),
                                    ),
                                  ),
                                );
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Movie ID not found",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: bfCard2(
                              image: movie['image'] ?? 'images/placeholder.jpg',
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}