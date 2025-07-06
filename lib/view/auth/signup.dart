
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController/signUpGetX.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import 'authWideget/SignButton.dart';
import 'authWideget/authTextForm.dart';
import 'authWideget/circularWidget.dart';

class signup extends StatelessWidget {
  const signup({super.key});

  @override
  Widget build(BuildContext context) {
    signUpGetx controller = Get.put(signUpGetx());

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
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() => controller.isloading.value
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  circularWidget(text: 'Create \n Account'),
                  SizedBox(height: 10),
                  styleText(
                      text: "Join us to get started!",
                      fSize: 30,
                      color: textColor1),
                  SizedBox(height: 20),
                  authTextForm(
                    hint: "Name",
                    sufIcon: Icon(Icons.person),
                    obscure: false,
                    textFormController: controller.name,
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
                  SizedBox(height: 20),
                  SignButton(
                    text: 'Sign Up',
                    color: secondaryColor,
                  ),
                  SizedBox(height: 20),
                  styleText(
                      text: "Already have an account?",
                      fSize: 30,
                      color: textColor1),
                  InkWell(
                    onTap: () {
                      controller.goToLogin();
                    },
                    child: styleText(
                      text: "Login",
                      fSize: 30,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}