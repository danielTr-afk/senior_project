import 'package:f_book2/view/Books/booksCategories.dart';
import 'package:f_book2/view/Books/booksListPage.dart';
import 'package:f_book2/view/HomePage/homePage.dart';
import 'package:f_book2/view/Movies/moviesListPage.dart';
import 'package:f_book2/view/auth/forgetPassword.dart';
import 'package:f_book2/view/auth/login.dart';
import 'package:f_book2/view/auth/otp.dart';
import 'package:f_book2/view/auth/signup.dart';
import 'package:f_book2/view/auth/updatePassword.dart';
import 'package:f_book2/view/onBoardingView/onBoarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/myBindings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: mybindings(),
      initialRoute: "/signup",
      getPages: [
        GetPage(name: "/onBoarding", page: () => onBoarding()),
        GetPage(name: "/login", page: () => login()),
        GetPage(name: "/signup", page: () => signup()),
        GetPage(name: "/homePage", page: () => homePage()),
        GetPage(name: "/booksListPage", page: () => booksListPage()),
        GetPage(name: "/moviesListPage", page: () => moviesListPage()),
        GetPage(name: "/booksCategories", page: () => booksCategories()),
        GetPage(name: "/otp", page: () => otp()),
        GetPage(name: "/forgotPassword", page: () => forgotPassword()),
        GetPage(name: "/updatePassword", page: () => updatePassword()),


      ],
    );
  }
}
