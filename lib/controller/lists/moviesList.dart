import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/GlobalWideget/styleText.dart';
import '../../view/Movies/MovieDetails/MovieDetailsPage.dart';
import '../movies/moviesController.dart';
import '../variables.dart';

class moviesSearchDelegate extends SearchDelegate {
  final moviesController controller = Get.find<moviesController>();

  @override
  String get searchFieldLabel => 'Search movies...';

  @override
  TextStyle? get searchFieldStyle => TextStyle(
    color: textColor2,
    fontSize: 18,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: mainColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor2),
        titleTextStyle: TextStyle(color: textColor2, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: mainColor2),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: textColor2, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear, color: textColor2),
          tooltip: 'Clear search',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back, color: textColor2),
      tooltip: 'Back',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return Container(
      color: mainColor,
      child: Obx(() {
        List<Map<String, dynamic>> moviesToShow;

        if (query.isEmpty) {
          moviesToShow = controller.movies.take(10).toList(); // Show first 10 movies when no query
        } else {
          moviesToShow = controller.searchMovies(query);
        }

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
                styleText(
                  text: controller.errorMessage.value,
                  fSize: 16,
                  color: mainColor2!,
                  textAlign: TextAlign.center,
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

        if (moviesToShow.isEmpty && query.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: mainColor2,
                ),
                SizedBox(height: 16),
                styleText(
                  text: "No movies found",
                  fSize: 20,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8),
                styleText(
                  text: "Try searching with different keywords\nlike title, category, or description",
                  fSize: 16,
                  color: mainColor2!,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (moviesToShow.isEmpty) {
          return Center(
            child: styleText(
              text: "Start typing to search movies...",
              fSize: 16,
              color: mainColor2!,
            ),
          );
        }

        return ListView.separated(
          itemCount: moviesToShow.length,
          separatorBuilder: (context, index) => Divider(
            color: mainColor2?.withOpacity(0.3),
            height: 1,
          ),
          itemBuilder: (context, index) {
            var movie = moviesToShow[index];
            return Container(
              color: mainColor,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie['image'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: mainColor2,
                        child: Icon(
                          Icons.movie,
                          color: textColor2,
                          size: 24,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: mainColor2,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: textColor2,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                title: styleText(
                  text: movie['title'] ?? 'Unknown Title',
                  fSize: 16,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (movie['description'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: styleText(
                          text: movie['description'],
                          fSize: 12,
                          color: mainColor2!,
                        ),
                      ),
                  ],
                ),
                trailing: SizedBox(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 14,
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            child: styleText(
                              text: movie['likes']?.toString() ?? '0',
                              fSize: 11,
                              color: mainColor2!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: mainColor2,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Close search and navigate to movie details
                  close(context, null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(
                        filmId: movie['id'].toString(),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}