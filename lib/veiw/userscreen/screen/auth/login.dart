import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/login_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/auth/forgetpassbutton.dart';
import 'package:hos/veiw/wedget/auth/google_face.dart';
import 'package:hos/veiw/wedget/auth/haveaccount.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: appexitAlert,
        child: GetBuilder<LoginController>(
          builder: (controller) {
            // ✅ الحالة loading فقط نعرض فيها Handlingdatrequest
            if (controller.statusrequest == Statusrequest.loading ||
                controller.statusrequest == Statusrequest.checkinterner) {
              return Handlingdatrequest(
                statusrequest: controller.statusrequest,
                widget: const SizedBox.shrink(),
              );
            }

            // ✅ باقي الحالات (success أو failure أو none)
            return Stack(
              alignment: Alignment.center,
              children: [
                // الخلفية
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Imageasset.see),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // أنميشن العلوية
                Positioned(
                  top: height * 0.05,
                  child: Animationlottie(
                    animationPath: Imageasset.loginanimation,
                  ),
                ),

                // نموذج تسجيل الدخول الزجاجي
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: width * 0.9,
                        constraints: BoxConstraints(maxHeight: height * 0.65),
                        decoration: BoxDecoration(
                          color: Appcolor.glass.withAlpha(51), // 0.2 * 255 = 51
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color.fromARGB(240, 145, 222, 255)
                                .withAlpha(77), // 0.3 * 255 = 77
                          ),
                        ),
                        child: Form(
                          key: loginController.loginkey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: height * 0.03),

                                  // 📩 البريد الإلكتروني
                                  Textfealdauth(
                                    valid: (val) =>
                                        validInput(val!, 9, 50, 'email'),
                                    textEditingController:
                                        loginController.email,
                                    label: 'email',
                                    suffixIcon: Icons.email_sharp,
                                    hint: 'Enter your Email',
                                  ),
                                  SizedBox(height: height * 0.025),

                                  // 🔐 كلمة المرور
                                  Textfealdauth(
                                    obscureText: controller.showpass,
                                    onTapIcon: () {
                                      controller.isshowpass();
                                    },
                                    valid: (val) =>
                                        validInput(val!, 5, 30, 'password'),
                                    textEditingController:
                                        loginController.passward,
                                    label: 'password',
                                    suffixIcon: Icons.password_sharp,
                                    hint: "Enter Your Password",
                                  ),

                                  // 🔹 رسالة الخطأ (في حالة failure فقط)
                                  if (controller.statusrequest ==
                                      Statusrequest.failure)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        " البريد الإلكتروني أو كلمة المرور غير صحيحة",
                                        style: TextStyle(
                                          color: Colors.red.shade400,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                  Forgetpassbutton(
                                    onPressed: () {
                                      loginController.checkemailpage();
                                    },
                                  ),

                                  SizedBox(height: height * 0.01),

                                  Checkbutton(
                                    onTap: () {
                                      loginController.login();
                                    },
                                    buttonName: 'Login',
                                    width: width * 0.75,
                                    buttonColor: Colors.deepPurple,
                                  ),

                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                      vertical: height * 0.02,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GoogleFacetweter(image: Imageasset.google),
                                        GoogleFacetweter(image: Imageasset.face),
                                        GoogleFacetweter(image: Imageasset.twetter),
                                      ],
                                    ),
                                  ),

                                  Haveaccount(),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
