import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/GlobalWideget/styleText.dart';
import '../../view/books/BookDetails/BookDetailsPage.dart';
import '../books/booksController.dart';
import '../variables.dart';

class booksSearchDelegate extends SearchDelegate {
  final BooksController controller = Get.find<BooksController>();

  @override
  String get searchFieldLabel => 'Search books...';

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
        List<Map<String, dynamic>> booksToShow;

        if (query.isEmpty) {
          booksToShow = controller.books.take(10).toList(); // Show first 10 books when no query
        } else {
          booksToShow = controller.books
              .where((book) {
            final title = book['title']?.toString().toLowerCase() ?? '';
            final author = book['author_name']?.toString().toLowerCase() ?? '';
            final description = book['description']?.toString().toLowerCase() ?? '';
            final searchQuery = query.toLowerCase();

            return title.contains(searchQuery) ||
                author.contains(searchQuery) ||
                description.contains(searchQuery);
          })
              .toList();
        }

        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: secondaryColor),
                SizedBox(height: 16),
                styleText(
                  text: "Loading books...",
                  fSize: 16,
                  color: textColor2,
                ),
              ],
            ),
          );
        }

        if (booksToShow.isEmpty && query.isNotEmpty) {
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
                  text: "No books found",
                  fSize: 20,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8),
                styleText(
                  text: "Try searching with different keywords",
                  fSize: 16,
                  color: mainColor2!,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (booksToShow.isEmpty) {
          return Center(
            child: styleText(
              text: "Start typing to search books...",
              fSize: 16,
              color: mainColor2!,
            ),
          );
        }

        return ListView.separated(
          itemCount: booksToShow.length,
          separatorBuilder: (context, index) => Divider(
            color: mainColor2?.withOpacity(0.3),
            height: 1,
          ),
          itemBuilder: (context, index) {
            var book = booksToShow[index];
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
                      book['image'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: mainColor2,
                        child: Icon(
                          Icons.book,
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
                  text: book['title'] ?? 'Unknown Title',
                  fSize: 16,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (book['author_name'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: styleText(
                          text: "by ${book['author_name']}",
                          fSize: 14,
                          color: mainColor2!,
                        ),
                      ),
                    if (book['description'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: styleText(
                          text: book['description'],
                          fSize: 12,
                          color: mainColor2!,
                        ),
                      ),
                  ],
                ),
                trailing: SizedBox(
                  width: 60,
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
                              text: book['likes']?.toString() ?? '0',
                              fSize: 11,
                              color: mainColor2!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: mainColor2,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Close search and navigate to book details
                  close(context, null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsPage(
                        bookId: book['id'].toString(),
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