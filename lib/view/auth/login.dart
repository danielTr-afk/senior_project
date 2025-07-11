import 'package:f_book2/view/auth/authWideget/circularWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController/loginGetX.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import 'authWideget/authTextForm.dart';
import 'authWideget/logButton.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    loginGetx controller = Get.put(loginGetx());

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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

          Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Welcome
                    const circularWidget(text: 'Welcome \n Back!'),

                    const SizedBox(height: 30),

                    // Login Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            styleText(
                              text: "Login to continue",
                              fSize: 28,
                              color: textColor1,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            authTextForm(
                              hint: "Email",
                              sufIcon: const Icon(Icons.email),
                              obscure: false,
                              textFormController: controller.email,
                            ),
                            const SizedBox(height: 14),
                            authTextForm(
                              hint: "Password",
                              sufIcon: const Icon(Icons.lock),
                              obscure: true,
                              textFormController: controller.password,
                            ),
                            const SizedBox(height: 24),
                            logButton(
                              text: 'Login',
                              color: textColor1,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    styleText(
                      text: "Don't have an account?",
                      fSize: 20,
                      color: textColor1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        controller.goToSignUp();
                      },
                      child: styleText(
                        text: "Sign Up",
                        fSize: 22,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(),

                    // Forgot password
                    InkWell(
                      onTap: () {
                        Get.toNamed("/forgotPassword");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: styleText(
                          text: "Forgot password?",
                          fSize: 16,
                          color: textColor1,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
