// ignore: file_names
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/sign_upcontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final Signupcontroller signUpcontroller = Get.put(Signupcontroller());

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: appexitAlert,
        child: GetBuilder<Signupcontroller>(
          builder: (controller) => Stack(
            alignment: Alignment.center,
            children: [
              // 🔹 الخلفية

              // 🔹 الأنيميشن أعلى الشاشة
              Positioned(
                top: height * 0.02,
                child: Column(
                  children: [
                    Animationlottie(
                      h: 200,
                      w: 200,
                      animationPath: Imageasset
                          .loginanimation, // أو اعمل signupanimation لو عندك
                    ),
                    Text(
                      "Create New Account".tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.black,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 الفورم الزجاجي
              Positioned(
                top: height * 0.30,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: width * 0.9,
                        constraints: BoxConstraints(maxHeight: height * 0.75),
                        decoration: BoxDecoration(
                          color: Appcolor.glass.withAlpha(51), // 0.2 * 255 = 51
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color.fromARGB(
                              240,
                              145,
                              222,
                              255,
                            ).withAlpha(77), // 0.3 * 255 = 77
                          ),
                        ),
                        child: Form(
                          key: signUpcontroller.signuokey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: height * 0.03),
                                  Textfealdauth(
                                    valid: (val) =>
                                        validInput(val!, 6, 20, "username"),
                                    textEditingController:
                                        signUpcontroller.username,
                                    // label: 'username',
                                    suffixIcon: Icons.person_outline,
                                    hint: "Enter Your username",
                                  ),
                                  SizedBox(height: height * 0.025),
                                  Textfealdauth(
                                    valid: (val) =>
                                        validInput(val!, 10, 30, "email"),
                                    textEditingController:
                                        signUpcontroller.email,
                                    // label: 'email',
                                    suffixIcon: Icons.email_outlined,
                                    hint: 'Enter your Email',
                                  ),
                                  SizedBox(height: height * 0.025),
                                  Textfealdauth(
                                    obscureText: controller.showpass,
                                    onTapIcon: () {
                                      controller.isshowpass();
                                    },
                                    valid: (val) =>
                                        validInput(val!, 5, 20, "password"),
                                    textEditingController:
                                        signUpcontroller.passward,
                                    // label: 'passward',
                                    suffixIcon: controller.showpass
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    hint: "Enter Your Passward",
                                  ),
                                  SizedBox(height: height * 0.025),
                                  GetBuilder<Signupcontroller>(
                                    builder: (controller) => Checkbutton(
                                      controller: controller,
                                      onTap: () {
                                        signUpcontroller.signup();
                                      },
                                      buttonName: 'Sign Up',
                                      width: width * 0.75,
                                      buttonColor: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  InkWell(
                                    onTap: () {
                                      signUpcontroller.gotologinin();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                        vertical: height * 0.015,
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "have An account ? ",
                                              style: TextStyle(
                                                color: Appcolor.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Login',
                                              style: TextStyle(
                                                color: Appcolor.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.03),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
