import 'package:f_book2/view/HomePage/homeWideGet/homeDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/authController/loginGetX.dart';
import '../../Author/AuthorDrawer.dart';
import '../../Director/DirectoreDrawer.dart';
import '../../Member/MemberDrawer.dart';


Widget getRoleBasedDrawer() {
  final loginController = Get.find<loginGetx>();

  switch (loginController.userRole.value) {
    case 2: // Author
      return AuthorDrawer();
    case 3: // Director
      return DirectoreDrawer();
    case 4: // Member
      return MemberDrawer();
    case 5: // Author_Director
    default:
      return homeDrawer();
  }
}