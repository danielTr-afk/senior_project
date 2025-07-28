import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/lists/moviesList.dart'; // controller
import '../../controller/movies/moviesController.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/listForm.dart';
import '../GlobalWideget/styleText.dart';
import '../HomePage/homeWideGet/homeDrawer.dart';
import '../Movies/MovieDetails/MovieDetailsPage.dart'; // Add this import

class moviesListPage extends StatelessWidget {
  const moviesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesController controller = Get.put(moviesController());

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
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: textColor2,)
        ),
        actions: [
          IconButton(
            color: textColor2,
            onPressed: () {
              showSearch(context: context, delegate: moviesSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.movies.isEmpty) {
          return const Center(child: Text("No movies found."));
        }

        return ListView.builder(
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
        );
      }),
    );
  }
}