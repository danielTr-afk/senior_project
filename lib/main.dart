import 'package:f_book2/view/Message/ChatPage.dart';
import 'package:f_book2/view/userProfile/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'controller/myBindings.dart';
import 'controller/splahScreen/splashScreen.dart';
import 'view/Message/message.dart';
import 'view/Movies/moviesCategories.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: mybindings(),
      initialRoute: "/homePage",
      getPages: [
        GetPage(name: "/splashScreen", page: () => splashScreen()),
        GetPage(name: "/onBoarding", page: () => onBoarding()),
        GetPage(name: "/login", page: () => login()),
        GetPage(name: "/signup", page: () => signup()),
        GetPage(name: "/homePage", page: () => homePage()),
        GetPage(name: "/booksListPage", page: () => booksListPage()),
        GetPage(name: "/moviesListPage", page: () => moviesListPage()),
        GetPage(name: "/booksCategories", page: () => booksCategories()),
        GetPage(name: "/moviesCategories", page: () => moviesCategories()),
        GetPage(name: "/otp", page: () => otp()),
        GetPage(name: "/forgotPassword", page: () => forgotPassword()),
        GetPage(name: "/updatePassword", page: () => updatePassword()),
        GetPage(name: "/message", page: () => message()),
        GetPage(name: "/ChatPage", page: () => ChatPage()),
        GetPage(name: "/ProfilePage", page: () => ProfilePage()),
      ],
    );
  }
}

