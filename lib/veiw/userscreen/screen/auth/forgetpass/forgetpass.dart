import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/checkemail_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckemailController());
    final size = MediaQuery.of(context).size;
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
      appBar: Appbarbackicon(herotag: "forgetpass", title: "", selected: false),
      body: SafeArea(
        child: GetBuilder<CheckemailController>(
          builder: (_) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.02),

                Animationlottie(
                  h: size.height * 0.22,
                  w: size.width * 0.55,
                  animationPath: Imageasset.email,
                ),

                SizedBox(height: size.height * 0.03),

                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                        vertical: 26,
                      ),
                      decoration: BoxDecoration(
                        color: glassColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: glassBorder, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 60 : 20),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Check Email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your email to receive a reset password code',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: subTextColor),
                          ),
                          SizedBox(height: size.height * 0.025),

                          Form(
                            key: controller.formstate,
                            child: Textfealdauth(
                              valid: (val) => validInput(val!, 6, 50, "email"),
                              textEditingController: controller.email,
                              suffixIcon: Icons.email_outlined,
                              hint: 'Enter your Email',
                            ),
                          ),

                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            child:
                                (controller.statusrequest ==
                                        Statusrequest.failure ||
                                    controller.statusrequest ==
                                        Statusrequest.checkinterner)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 12),
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
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            controller.statusrequest ==
                                                    Statusrequest.checkinterner
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
                                                  : (controller.errorMessage),
                                              style: TextStyle(
                                                color: Colors.red.shade400,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          SizedBox(height: size.height * 0.02),

                          SizedBox(
                            child: GetBuilder<CheckemailController>(
                              builder: (controller) {
                                return Checkbutton(
                                  width: size.width * 0.8,
                                  statusrequest: controller.statusrequest,
                                  onTap: () => controller.checkemail(),
                                  buttonName: 'Send Code',
                                  buttonColor: Appcolor.primaryColor,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
