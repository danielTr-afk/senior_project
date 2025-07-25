import 'package:f_book2/view/userProfile/AboutUsPage.dart';
import 'package:f_book2/view/Books/BookDetails/BookDetailsPage.dart';
import 'package:f_book2/view/Books/addBook.dart';
import 'package:f_book2/view/userProfile/HelpPage.dart';
import 'package:f_book2/view/Message/ChatPage.dart';
import 'package:f_book2/view/Message/usersPage.dart';
import 'package:f_book2/view/Movies/MovieDetails/MovieDetailsPage.dart';
import 'package:f_book2/view/Movies/addMovie.dart';
import 'package:f_book2/view/contract/AcceptContractPage.dart';
import 'package:f_book2/view/contract/createContract.dart';
import 'package:f_book2/view/setting/settingPage.dart';
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
      initialRoute: "/login",
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
        GetPage(name: "/BookDetailsPage", page: () => BookDetailsPage()),
        GetPage(name: "/MovieDetailsPage", page: () => MovieDetailsPage()),
        GetPage(name: "/settingsPage", page: () => settingsPage()),
        GetPage(name: "/AcceptContractPage", page: () => AcceptContractPage()),
        GetPage(name: "/createContract", page: () => createContract()),
        GetPage(name: "/addBook", page: () => addBook()),
        GetPage(name: "/addMovie", page: () => addMovie()),
        GetPage(name: "/usersPage", page: () => usersPage()),
        GetPage(name: "/AboutUsPage", page: () => AboutUsPage()),
        GetPage(name: "/HelpPage", page: () => HelpPage()),


      ],
    );
  }
}











