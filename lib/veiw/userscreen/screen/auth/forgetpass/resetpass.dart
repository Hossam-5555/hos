import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/resetpasscontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Resetpass extends StatelessWidget {
  const Resetpass({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Resetpasscontroller());
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar:Appbarbackicon(title: "", herotag: "Resetpass", selected: false),
      body: SafeArea(
        child: GetBuilder<Resetpasscontroller>(
          builder: (_) => HandlingDataView(
            onTapError: () {
              controller.statusrequest = Statusrequest.none;
              controller.update();
            },
            statusrequest: controller.statusrequest,
            widget: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.07,
                  vertical: 20,
                ),
                child: Form(
                  key: controller.formstate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.02),

                      Container(
                        height: 84,
                        width: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Appcolor.primaryColor.withAlpha(isDark ? 40 : 25),
                        ),
                        child: Icon(
                          Icons.lock_reset_rounded,
                          size: 40,
                          color: Appcolor.primaryColor,
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      Text(
                        'Create New Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Your new password must be different from previous passwords',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: subTextColor),
                      ),

                      SizedBox(height: size.height * 0.05),

                      Textfealdauth(
                        valid: (val) => validInput(val!, 6, 30, "password"),
                        hint: 'Enter new password',
                        textEditingController: controller.password,
                        suffixIcon: Icons.lock_outline,
                      ),

                      SizedBox(height: size.height * 0.02),

                      Textfealdauth(
                        valid: (val) {
                          if (val != controller.password.text) {
                            return "Passwords do not match";
                          }
                          return validInput(val!, 6, 30, "password");
                        },
                        hint: 'Confirm password',
                        textEditingController: controller.repassword,
                        suffixIcon: Icons.lock_outline,
                      ),

                      SizedBox(height: size.height * 0.05),

                      SizedBox(
                        width: double.infinity,
                        child: Checkbutton(
                          statusrequest: controller.statusrequest,
                          onTap: () => controller.gotosuccesreset(),
                          buttonName: 'Reset Password',
                          buttonColor: Appcolor.primaryColor,
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}