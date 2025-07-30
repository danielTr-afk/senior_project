import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../controller/profileSetting/FavoritesController.dart';
import '../../controller/variables.dart';
import '../Books/BookDetails/BookDetailsPage.dart';
import '../GlobalWideget/styleText.dart';
import '../Movies/MovieDetails/MovieDetailsPage.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController = Get.put(FavoritesController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: styleText(
            text: "Favorites",
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
          bottom: TabBar(
            indicatorColor: secondaryColor,
            labelColor: secondaryColor,
            unselectedLabelColor: mainColor2,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book, size: 16),
                    SizedBox(width: 4),
                    Text("Books"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie, size: 16),
                    SizedBox(width: 4),
                    Text("Movies"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.all_inclusive, size: 16),
                    SizedBox(width: 4),
                    Text("All"),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (favoritesController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: secondaryColor),
            );
          }

          return TabBarView(
            children: [
              // Books Tab
              _buildBooksTab(favoritesController),
              // Movies Tab
              _buildMoviesTab(favoritesController),
              // All Tab
              _buildAllTab(favoritesController),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBooksTab(FavoritesController controller) {
    return Obx(() {
      if (controller.favoriteBooks.isEmpty) {
        return _buildEmptyState(
          icon: Icons.book_outlined,
          title: "No favorite books",
          subtitle: "Add books to your favorites to see them here",
        );
      }

      return RefreshIndicator(
        color: secondaryColor,
        backgroundColor: mainColor,
        onRefresh: controller.refreshFavorites,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          itemCount: controller.favoriteBooks.length,
          itemBuilder: (context, index) {
            final book = controller.favoriteBooks[index];
            return _buildFavoriteItem(
              item: book,
              type: 'book',
              onTap: () {
                Get.to(() => BookDetailsPage(
                  bookId: book['id'].toString(),
                ));
              },
              onRemove: () {
                controller.removeBookFromFavorites(book['id'].toString());
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildMoviesTab(FavoritesController controller) {
    return Obx(() {
      if (controller.favoriteMovies.isEmpty) {
        return _buildEmptyState(
          icon: Icons.movie_outlined,
          title: "No favorite movies",
          subtitle: "Add movies to your favorites to see them here",
        );
      }

      return RefreshIndicator(
        color: secondaryColor,
        backgroundColor: mainColor,
        onRefresh: controller.refreshFavorites,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          itemCount: controller.favoriteMovies.length,
          itemBuilder: (context, index) {
            final movie = controller.favoriteMovies[index];
            return _buildFavoriteItem(
              item: movie,
              type: 'movie',
              onTap: () {
                Get.to(() => MovieDetailsPage(
                  filmId: movie['id'].toString(),
                ));
              },
              onRemove: () {
                controller.removeMovieFromFavorites(movie['id'].toString());
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildAllTab(FavoritesController controller) {
    return Obx(() {
      final allFavorites = controller.allFavorites;

      if (allFavorites.isEmpty) {
        return _buildEmptyState(
          icon: Icons.favorite_outline,
          title: "No favorites",
          subtitle: "Add books and movies to your favorites to see them here",
        );
      }

      return RefreshIndicator(
        color: secondaryColor,
        backgroundColor: mainColor,
        onRefresh: controller.refreshFavorites,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          itemCount: allFavorites.length,
          itemBuilder: (context, index) {
            final item = allFavorites[index];
            final itemType = item['type'];

            return _buildFavoriteItem(
              item: item,
              type: itemType,
              onTap: () {
                if (itemType == 'book') {
                  Get.to(() => BookDetailsPage(
                    bookId: item['id'].toString(),
                  ));
                } else {
                  Get.to(() => MovieDetailsPage(
                    filmId: item['id'].toString(),
                  ));
                }
              },
              onRemove: () {
                if (itemType == 'book') {
                  controller.removeBookFromFavorites(item['id'].toString());
                } else {
                  controller.removeMovieFromFavorites(item['id'].toString());
                }
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildFavoriteItem({
    required Map<String, dynamic> item,
    required String type,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: blackColor2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              Hero(
                tag: '${type}_${item['id']}',
                child: Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[800],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item['image'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(
                            color: secondaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: Icon(
                          type == 'book' ? Icons.book : Icons.movie,
                          size: 30,
                          color: textColor2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: type == 'book' ? Colors.blue.withOpacity(0.2) : Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: type == 'book' ? Colors.blue : Colors.purple,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                type == 'book' ? Icons.book : Icons.movie,
                                size: 12,
                                color: type == 'book' ? Colors.blue : Colors.purple,
                              ),
                              SizedBox(width: 4),
                              styleText(
                                text: type == 'book' ? 'Book' : 'Movie',
                                fSize: 10,
                                color: type == 'book' ? Colors.blue : Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: onRemove,
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    styleText(
                      text: item['title'] ?? 'Unknown Title',
                      fSize: 18,
                      color: textColor2,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    if (item['description'] != null)
                      styleText(
                        text: item['description'],
                        fSize: 14,
                        color: mainColor2!,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        styleText(
                          text: "${item['likes'] ?? 0}",
                          fSize: 14,
                          color: mainColor2!,
                        ),
                        if (item['rating'] != null) ...[
                          SizedBox(width: 16),
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          styleText(
                            text: "${item['rating'] ?? 0.0}",
                            fSize: 14,
                            color: mainColor2!,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return RefreshIndicator(
      onRefresh: () => Get.find<FavoritesController>().refreshFavorites(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: mainColor2,
              ),
              SizedBox(height: 16),
              styleText(
                text: title,
                fSize: 22,
                color: textColor2,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: styleText(
                  text: subtitle,
                  fSize: 16,
                  color: mainColor2!,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}