import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/authController/loginGetX.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import 'authWideget/authTextForm.dart';
import 'authWideget/circularWidget.dart';
import 'authWideget/logButton.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    loginGetx controller = Get.put(loginGetx());

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [mainColor, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
      Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 20,
                ),
                circularWidget(
                  text: 'Welcome \n Back!',
                ),
                SizedBox(
                  height: 10,
                ),
                styleText(
                    text: "Login to continue", fSize: 30, color: textColor1),
                SizedBox(
                  height: 20,
                ),
                authTextForm(
                  hint: "Email",
                  sufIcon: Icon(Icons.email),
                  obscure: false,
                  textFormController: controller.email,
                ),
                authTextForm(
                  hint: "Password",
                  sufIcon: Icon(Icons.lock),
                  obscure: true,
                  textFormController: controller.password,
                ),
                SizedBox(
                  height: 20,
                ),
                logButton(
                  text: 'Login',
                  color: textColor1,
                ),
                SizedBox(
                  height: 20,
                ),
                styleText(
                    text: "Don't have an account?",
                    fSize: 30,
                    color: textColor1),
                InkWell(
                  onTap: () {
                    controller.goToSignUp();
                  },
                  child: styleText(
                    text: "Sign Up",
                    fSize: 30,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed("/forgotPassword");
                  },
                  child: styleText(
                    text: "forget password ?",
                    fSize: 15,
                    color: textColor1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
      )
          ],
        ),
      ),
    );
  }
}
