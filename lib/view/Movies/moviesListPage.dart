import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/lists/moviesList.dart';
import '../../controller/movies/moviesController.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/listForm.dart';
import '../GlobalWideget/styleText.dart';
import '../Movies/MovieDetails/MovieDetailsPage.dart';

class moviesListPage extends StatelessWidget {
  const moviesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is properly initialized
    final controller = Get.put(moviesController());

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: styleText(
          text: "Movies",
          fSize: 30,
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: mainColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: textColor2),
        ),
        actions: [
          IconButton(
            color: textColor2,
            onPressed: () {
              showSearch(context: context, delegate: moviesSearchDelegate());
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search movies',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: secondaryColor),
                SizedBox(height: 16),
                styleText(
                  text: "Loading movies...",
                  fSize: 16,
                  color: textColor2,
                ),
              ],
            ),
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
                SizedBox(height: 16),
                styleText(
                  text: "Error loading movies",
                  fSize: 20,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: styleText(
                    text: controller.errorMessage.value,
                    fSize: 16,
                    color: mainColor2!,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16),
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

        if (controller.movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_outlined,
                  size: 64,
                  color: mainColor2,
                ),
                SizedBox(height: 16),
                styleText(
                  text: "No movies available",
                  fSize: 20,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8),
                styleText(
                  text: "Check back later for new movies",
                  fSize: 16,
                  color: mainColor2!,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshMovies(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                  ),
                  child: styleText(
                    text: "Refresh",
                    fSize: 16,
                    color: textColor2,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: secondaryColor,
          backgroundColor: mainColor,
          onRefresh: () => controller.refreshMovies(),
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            itemCount: controller.movies.length,
            itemBuilder: (context, index) {
              final movie = controller.movies[index];
              return listForm(
                title: movie['title'] ?? 'No Title',
                subtitle: movie['description'] ?? '',
                nav: "", // Keep empty since we're using custom onTap
                image: movie['image'] ?? 'images/placeholder.jpg',
                numLike: movie['likes']?.toString() ?? '0',
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
              );
            },
          ),
        );
      }),
    );
  }
}