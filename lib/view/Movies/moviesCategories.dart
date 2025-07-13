import 'package:f_book2/view/GlobalWideget/bfCrad2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/movies/moviesController.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import '../HomePage/homeWideGet/homeBottomNav.dart';
import '../HomePage/homeWideGet/homeDrawer.dart';
import '../HomePage/homeWideGet/titleSection.dart';

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
            icon: Icon(Icons.list, size: 30, color: textColor2),
          ),
        ),
      ),
      drawer: homeDrawer(),
      bottomNavigationBar: homeBottomNav(index: 2),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = controller.categorizedMovies.keys.toList();

        return Container(
          padding: const EdgeInsets.all(15),
          color: blackColor2,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final movies = controller.categorizedMovies[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleSection(
                    text: category,
                    onTap: "/moviesListPage", // optional route
                    color: textColor2,
                  ),
                  SizedBox(
                    height: 315,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, i) {
                        final movie = movies[i];
                        return bfCard2(image: movie['image']);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}