import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/variables.dart';
import 'styleText.dart';

class listForm extends StatelessWidget {
  const listForm({super.key, required this.title, required this.subtitle, required this.nav, required this.image, required this.numLike});

  final String title;
  final String subtitle;
  final String nav;
  final String image;
  final String numLike;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: (){
            Get.offAll(nav);
          },
          leading: Image.network(image),
          title: styleText(text: title, fSize: 30, color: textColor2, fontWeight: FontWeight.bold,),
          subtitle: styleText(text: "$subtitle. \nNumber of like $numLike", fSize: 20, color: mainColor2!,),
          trailing: Icon(Icons.navigate_next, size: 40, color: textColor2,),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          tileColor: blackColor2,
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
