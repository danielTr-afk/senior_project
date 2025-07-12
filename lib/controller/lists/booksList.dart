import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/GlobalWideget/styleText.dart';
import '../books/booksController.dart';
import '../variables.dart';

final controller = Get.put(BooksController());
List? filterList;

class booksSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List booksToShow;

    if (query.isEmpty) {
      booksToShow = controller.books;
    } else {
      booksToShow = controller.books
          .where((element) => element['title']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    }

    return ListView.builder(
      itemCount: booksToShow.length,
      itemBuilder: (context, index) {
        var book = booksToShow[index];
        return ListTile(
          title: styleText(
            text: book['title'],
            fSize: 20,
            color: mainColor,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

}


