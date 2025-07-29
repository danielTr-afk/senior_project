import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/books/booksController.dart';
import '../../controller/lists/booksList.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/listForm.dart';
import '../GlobalWideget/styleText.dart';
import 'BookDetails/BookDetailsPage.dart';

class booksListPage extends StatelessWidget {
  booksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is properly initialized
    final controller = Get.put(BooksController());

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: styleText(
          text: "Books",
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
              showSearch(context: context, delegate: booksSearchDelegate());
            },
            icon: Icon(Icons.search),
            tooltip: 'Search books',
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Obx(() {
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

          if (controller.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 64,
                    color: mainColor2,
                  ),
                  SizedBox(height: 16),
                  styleText(
                    text: "No books available",
                    fSize: 20,
                    color: textColor2,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 8),
                  styleText(
                    text: "Check back later for new books",
                    fSize: 16,
                    color: mainColor2!,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchBooks(),
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
            onRefresh: () => controller.fetchBooks(),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: controller.books.length,
              itemBuilder: (BuildContext context, int index) {
                var book = controller.books[index];
                return listForm(
                  title: book['title'],
                  subtitle: book['description'],
                  nav: "", // Keep empty since we're using custom onTap
                  image: book['image'],
                  numLike: book['likes'],
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
                );
              },
            ),
          );
        }),
      ),
    );
  }
}