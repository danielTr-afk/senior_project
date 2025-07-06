import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/books/BooksController.dart';
import '../../controller/lists/booksList.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/listForm.dart';
import '../GlobalWideget/styleText.dart';
import '../HomePage/homeWideGet/homeDrawer.dart';

class booksListPage extends StatelessWidget {
   booksListPage({super.key});

  final controller = Get.put(BooksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: styleText(text: "Books", fSize: 30, color: secondaryColor, fontWeight: FontWeight.bold,),
        backgroundColor: mainColor,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.list,
                size: 30, color: textColor2),
          ),
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

      drawer: homeDrawer(),

      body: Container(
        padding: EdgeInsets.all(15),
        child:Obx(() {
          return ListView.builder(
            itemCount: controller.books.length,
             itemBuilder: (BuildContext context, int index) {
               var book = controller.books[index];
               return listForm(title: book['title'], subtitle: book['description'], nav: "nav", image: book['image'], numLike: book['likes'],);
             },

        );
        }
    )
      ),

    );
  }
}
