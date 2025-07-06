import 'package:flutter/material.dart';
import '../../view/GlobalWideget/styleText.dart';
import '../variables.dart';

class moviesSearchDelegate extends SearchDelegate {
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
    if(query == ''){
      return ListView.builder(
          itemCount: test.length,
          itemBuilder: (context, index) => ListTile(
            title: styleText(text: test[index], fSize: 20, color: mainColor, textAlign: TextAlign.center,),
          )
      );
    }else{
      filterList = test.where((element) => element.contains(query)).toList();
      return ListView.builder(
          itemCount: filterList!.length,
          itemBuilder: (context, index) => ListTile(
            title: styleText(text: filterList![index], fSize: 20, color: mainColor, textAlign: TextAlign.center,),
          )
      );
    }
  }
}

List test = [
  'daniel',
  'ali',
  'ahmad',
];

List? filterList ;
