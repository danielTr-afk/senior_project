import 'package:f_book2/view/auth/authWideget/circularWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController/signUpGetX.dart';
import '../../controller/variables.dart';
import '../GlobalWideget/styleText.dart';
import 'authWideget/SignButton.dart';
import 'authWideget/authTextForm.dart';

class signup extends StatelessWidget {
  const signup({super.key});

  @override
  Widget build(BuildContext context) {
    signUpGetx controller = Get.put(signUpGetx());

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
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

          Obx(() => controller.isloading.value
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
                    const SizedBox(height: 50),

                    // Title
                    const circularWidget(text: 'Create \n Account'),

                    const SizedBox(height: 20),

                    // Subtitle
                    styleText(
                      text: "Join us to get started!",
                      fSize: 28,
                      color: textColor1,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Form Section
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            authTextForm(
                              hint: "Name",
                              sufIcon: const Icon(Icons.person),
                              obscure: false,
                              textFormController: controller.name,
                            ),
                            const SizedBox(height: 14),
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
                            SignButton(
                              text: 'Sign Up',
                              color: secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Already have an account?
                    styleText(
                      text: "Already have an account?",
                      fSize: 20,
                      color: textColor1,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    InkWell(
                      onTap: () {
                        controller.goToLogin();
                      },
                      child: styleText(
                        text: "Login",
                        fSize: 22,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(),

                    const SizedBox(height: 20),
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
