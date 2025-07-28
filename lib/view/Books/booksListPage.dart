import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/books/booksController.dart';
import '../../controller/lists/booksList.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/listForm.dart';
import '../GlobalWideget/styleText.dart';
import 'BookDetails/BookDetailsPage.dart'; // Add this import

class booksListPage extends StatelessWidget {
  booksListPage({super.key});

  final controller = Get.put(BooksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: styleText(text: "Books", fSize: 30, color: secondaryColor, fontWeight: FontWeight.bold,),
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
                showSearch(context: context, delegate: booksSearchDelegate());
              },
              icon: Icon(Icons.search))
        ],
      ),

      body: Container(
          padding: EdgeInsets.all(15),
          child:Obx(() {
            return ListView.builder(
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
            );
          }
          )
      ),

    );
  }
}