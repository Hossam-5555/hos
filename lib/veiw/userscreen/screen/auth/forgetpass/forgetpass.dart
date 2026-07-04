import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/checkemail_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
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

    return Scaffold(
      appBar:Appbarbackicon(
        herotag: "forgetpass",
        title: "Forget Password",
        selected: false,
      ),
      body: SafeArea(
        child: GetBuilder<CheckemailController>(
          builder: (_) => Handlingdatrequest(
            onTapError: () {
              controller.statusrequest =
                  Statusrequest.none; // أو الحالة الافتراضية عندك
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.02),

                    /// 🟢 عنوان
                    Text(
                      'Check Email',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall!,
                    ),

                    const SizedBox(height: 10),

                    /// 🟢 الوصف
                    Text(
                      'Enter your email to receive a reset password code',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: Appcolor.grey),
                    ),

                    SizedBox(height: size.height * 0.04),

                    /// 🟢 انيميشن
                    Animationlottie(
                      h: size.height * 0.25,
                      w: size.width * 0.6,
                      animationPath: Imageasset.email,
                    ),

                    SizedBox(height: size.height * 0.05),

                    /// 🟢 الفورم
                    Form(
                      key: controller.formstate,
                      child: Textfealdauth(
                        valid: (val) {
                          return validInput(val!, 10, 30, "email");
                        },
                        textEditingController: controller.email,
                        suffixIcon: Icons.email_outlined,
                        hint: 'Enter your Email',
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    /// 🟢 الزرار
                    SizedBox(
                      width: double.infinity,
                      child: Checkbutton(
                        onTap: () {
                          controller.checkemail();
                        },
                        buttonName: 'Send Code',
                        buttonColor: Appcolor.black,
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
    );
  }
}
