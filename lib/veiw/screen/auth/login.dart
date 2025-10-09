import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/auth/login_controller.dart';
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
    // 🔹 وضعنا الـ Controller هنا ليبقى متاحاً
    final LoginController loginController = Get.put(LoginController());

    // 🔹 الحصول على حجم الشاشة
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      // 🔹 resizeToAvoidBottomInset: false لتجنب تغيير حجم الخلفية عند ظهور الكيبورد
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: appexitAlert,
        child: GetBuilder<LoginController>(
          builder: (controller) => Handlingdatrequest(
            statusrequest: controller.statusrequest,
            // 🔹 الهيكل الرئيسي: Stack ليغطي الشاشة بأكملها
            widget: Stack(
              alignment: Alignment.center,
              children: [
                // 🔹 الخلفية: ستملأ الشاشة بالكامل
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        Imageasset.see,
                      ), // تأكد من أن هذا المسار صحيح 100%
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // 🔹 الأنيميشن: يظهر في المنتصف فوق الخلفية
                Positioned(
                  top: height * 0.05, // تحديد موقعه في الأعلى قليلاً
                  child: Animationlottie(
                    animationPath: Imageasset.loginanimation,
                  ),
                ),

                // 🔹 نموذج تسجيل الدخول الزجاجي
                // تم وضعه داخل Center ليتم توسيطه تلقائياً بدلاً من Positioned
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      25,
                    ), // تعديل بسيط لشكل الحواف
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: width * 0.9,
                        // 🔹 استخدمنا maxHeight لمنع التمدد الزائد
                        constraints: BoxConstraints(maxHeight: height * 0.65),
                        decoration: BoxDecoration(
                          color: Appcolor.glass.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color.fromARGB(
                              240,
                              145,
                              222,
                              255,
                            ).withOpacity(0.3),
                          ),
                        ),
                        // 🔹 تمت إضافة Form هنا
                        child: Form(
                          key: loginController.loginkey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                            ),
                            // 🔹 مهم جداً: SingleChildScrollView يكون هنا بالداخل
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 🔹 مسافة علوية داخل النموذج
                                  SizedBox(height: height * 0.03),
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
                                  // 🔹 لا داعي لـ GetBuilder آخر هنا
                                  Textfealdauth(
                                    obscureText: controller.showpass,
                                    onTapIcon: () {
                                      controller.isshowpass();
                                    },
                                    valid: (val) =>
                                        validInput(val!, 5, 30, 'password'),
                                    textEditingController:
                                        loginController.passward,
                                    label: 'passward',
                                    suffixIcon: Icons.password_sharp,
                                    hint: "Enter Your Passward",
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
                                        Google_Face(image: Imageasset.google),
                                        Google_Face(image: Imageasset.face),
                                        Google_Face(image: Imageasset.twetter),
                                      ],
                                    ),
                                  ),
                                  Haveaccount(),
                                  // 🔹 مسافة سفلية داخل النموذج
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
            ),
          ),
        ),
      ),
    );
  }
}
