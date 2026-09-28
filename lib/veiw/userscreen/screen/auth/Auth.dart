import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/auth_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/auth/forgetpassbutton.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final glassColor = isDark
        ? Colors.white.withAlpha(15)
        : Appcolor.glass.withAlpha(51);
    final glassBorder = isDark
        ? Colors.white.withAlpha(40)
        : const Color.fromARGB(240, 145, 222, 255).withAlpha(77);
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      resizeToAvoidBottomInset: true, // السماح بالتجاوب مع الكيبورد
      body: SafeArea(
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: appexitAlert,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: isDark
                    ? [const Color(0xFF0E0E1A), const Color(0xFF1A1A2E)]
                    : [const Color(0xFFEAF2FF), const Color(0xFFFFFFFF)],
              ),
            ),
            child: GetBuilder<AuthController>(
              builder: (controller) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                        vertical: height * 0.02,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // حجم مرن للأنيميشن
                          SizedBox(
                            height: height * 0.2,
                            width: height * 0.2,
                            child: Animationlottie(
                              h: height * 0.2,
                              w: height * 0.2,
                              animationPath: Imageasset.loginanimation,
                            ),
                          ),
                          SizedBox(height: height * 0.015),

                          // الحاوية الضبابية (Glassmorphism Container)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                  color: glassColor,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: glassBorder,
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(
                                        isDark ? 60 : 20,
                                      ),
                                      blurRadius: 24,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: controller.formKey,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05,
                                      vertical: height * 0.02,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _ModeSwitcher(
                                          isLogin: controller.isLogin,
                                          onChanged: (value) {
                                            if (value != controller.isLogin) {
                                              controller.toggleMode();
                                            }
                                          },
                                        ),

                                        SizedBox(height: height * 0.020),

                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: Text(
                                            controller.isLogin
                                                ? "Welcome Back".tr
                                                : "Create New Account".tr,
                                            key: ValueKey(controller.isLogin),
                                            style: TextStyle(
                                              fontSize: width * 0.055 > 24 ? 24 : width * 0.055,
                                              fontWeight: FontWeight.bold,
                                              color: titleColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.006),
                                        Text(
                                          controller.isLogin
                                              ? "Login to continue shopping".tr
                                              : "Sign up to start shopping".tr,
                                          style: TextStyle(
                                            fontSize: width * 0.032 > 13 ? 13 : width * 0.032,
                                            color: subTextColor,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.020),

                                        AnimatedSize(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOutCubic,
                                          child: !controller.isLogin
                                              ? Column(
                                                  children: [
                                                    Textfealdauth(
                                                      valid: (val) => validInput(
                                                        val!,
                                                        3,
                                                        20,
                                                        "username",
                                                      ),
                                                      textEditingController:
                                                          controller.username,
                                                      suffixIcon:
                                                          Icons.person_outline,
                                                      hint: "Enter Your username",
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ),

                                        Textfealdauth(
                                          valid: (val) =>
                                              validInput(val!, 6, 50, 'email'),
                                          textEditingController: controller.email,
                                          suffixIcon: Icons.email_outlined,
                                          hint: 'Email Address',
                                        ),
                                        SizedBox(height: height * 0.01),

                                        Textfealdauth(
                                          obscureText: controller.showpass,
                                          onTapIcon: () =>
                                              controller.isshowpass(),
                                          valid: (val) =>
                                              validInput(val!, 6, 30, 'password'),
                                          textEditingController:
                                              controller.passward,
                                          suffixIcon: controller.showpass
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          hint: "Password",
                                        ),

                                        if (controller.statusrequest ==
                                                Statusrequest.failure ||
                                            controller.statusrequest ==
                                                Statusrequest.checkinterner)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.01,
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withAlpha(
                                                  isDark ? 40 : 20,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.red.shade300,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    controller.statusrequest ==
                                                            Statusrequest
                                                                .checkinterner
                                                        ? Icons.wifi_off_rounded
                                                        : Icons.error_outline,
                                                    color: Colors.red.shade400,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      controller.statusrequest ==
                                                              Statusrequest
                                                                  .checkinterner
                                                          ? "تأكد من اتصالك بالإنترنت وحاول مرة أخرى"
                                                          : (controller.isLogin
                                                                ? "البريد الإلكتروني أو كلمة المرور غير صحيحة"
                                                                : "حدث خطأ، من فضلك حاول مرة أخرى"),
                                                      style: TextStyle(
                                                        color:
                                                            Colors.red.shade400,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        AnimatedSize(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: controller.isLogin
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Forgetpassbutton(
                                                    onPressed: () => controller
                                                        .checkemailpage(),
                                                  ),
                                                )
                                              : SizedBox(height: height * 0.012),
                                        ),

                                        SizedBox(height: height * 0.015),

                                        Checkbutton(
                                          statusrequest: controller.statusrequest,
                                          onTap: () => controller.submit(),
                                          buttonName: controller.isLogin
                                              ? 'Login'
                                              : 'Create Account',
                                          width: width * 0.75,
                                          buttonColor: Appcolor.primaryColor,
                                        ),

                                        SizedBox(height: height * 0.018),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: subTextColor.withAlpha(80),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Text(
                                                "or continue with".tr,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: subTextColor,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: subTextColor.withAlpha(80),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: height * 0.015),

                                        Checkbutton.widget(
                                          widget: SvgPicture.asset(
                                            Imageasset.googlepay,
                                            height: 20,
                                            width: 20,
                                          ),
                                          statusrequest: Statusrequest.none,
                                          onTap: () => controller.submit(),
                                          buttonName: 'google',
                                          width: width * 0.75,
                                          buttonColor: isDark
                                              ? Colors.white.withAlpha(20)
                                              : Colors.white.withAlpha(140),
                                        ),

                                        SizedBox(height: height * 0.015),

                                        GestureDetector(
                                          onTap: () => controller.toggleMode(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: controller.isLogin
                                                        ? "Don't have an account? "
                                                              .tr
                                                        : "Already have an account? "
                                                              .tr,
                                                    style: TextStyle(
                                                      color: subTextColor,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: controller.isLogin
                                                        ? "Sign Up".tr
                                                        : "Login".tr,
                                                    style: TextStyle(
                                                      color:
                                                          Appcolor.primaryColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: height * 0.01),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChanged;

  const _ModeSwitcher({required this.isLogin, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark
        ? Colors.white.withAlpha(20)
        : Colors.black.withAlpha(15);
    final inactiveText = isDark ? Colors.white70 : Colors.black54;

    return Container(
      height: 46,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: isLogin ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Appcolor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolor.primaryColor.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "Login".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isLogin ? Colors.white : inactiveText,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "Sign Up".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !isLogin ? Colors.white : inactiveText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}