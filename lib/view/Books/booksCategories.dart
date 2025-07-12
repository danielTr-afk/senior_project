import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/books/booksController.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/bfCrad2.dart';
import '../GlobalWideget/styleText.dart';
import '../HomePage/homeWideGet/homeBottomNav.dart';
import '../HomePage/homeWideGet/homeDrawer.dart';
import '../HomePage/homeWideGet/titleSection.dart';

class booksCategories extends StatelessWidget {
  const booksCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final booksController = Get.put(BooksController());

    return Scaffold(
      appBar: AppBar(
        title: styleText(
          text: "Books Categories",
          fSize: 30,
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: mainColor,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu, size: 30, color: textColor2),
          ),
        ),
      ),
      drawer: homeDrawer(),
      bottomNavigationBar: homeBottomNav(index: 1),
      body: Container(
        padding: const EdgeInsets.all(15),
        color: textColor2,
        child: Obx(() {
          if (booksController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final groupedBooks = <String, List<Map<String, dynamic>>>{};
          for (var book in booksController.books) {
            String category = book['category'] ?? 'Unknown';
            groupedBooks.putIfAbsent(category, () => []).add(book);
          }

          return ListView(
            children: groupedBooks.entries.map((entry) {
              final categoryName = entry.key;
              final booksInCategory = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleSection(
                    text: categoryName,
                    color: mainColor,
                    onTap: "/booksListPage", // You can later pass category name
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: booksInCategory.length,
                      itemBuilder: (context, index) {
                        final book = booksInCategory[index];
                        return bfCard2(
                          image: book['image'] ?? 'images/booksImage/default.jpg',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
