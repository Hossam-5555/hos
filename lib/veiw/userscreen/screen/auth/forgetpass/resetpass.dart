import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/resetpasscontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Resetpass extends StatelessWidget {
  const Resetpass({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Resetpasscontroller());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Appcolor.black,
      ),
      body: SafeArea(
        child: GetBuilder<Resetpasscontroller>(
          builder: (_) => HandlingDataView(
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
                child: Form(
                  key: controller.formstate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.03),

                      /// 🟢 عنوان
                      Text(
                        'Create New Password',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: Appcolor.black,
                            ),
                      ),

                      const SizedBox(height: 10),

                      /// 🟢 وصف
                      Text(
                        'Your new password must be different from previous passwords',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                      ),

                      SizedBox(height: size.height * 0.05),

                      /// 🟢 Password
                      Textfealdauth(
                        valid: (val) {
                          return validInput(val!, 10, 30, "password");
                        },
                        hint: 'Enter new password',
                        textEditingController: controller.password,
                        suffixIcon: Icons.lock_outline,
                      ),

                      SizedBox(height: size.height * 0.03),

                      /// 🟢 Confirm Password
                      Textfealdauth(
                        valid: (val) {
                          if (val != controller.password.text) {
                            return "Passwords do not match";
                          }
                          return validInput(val!, 10, 30, "password");
                        },
                        hint: 'Confirm password',
                        textEditingController: controller.repassword,
                        suffixIcon: Icons.lock_outline,
                      ),

                      SizedBox(height: size.height * 0.05),

                      /// 🟢 زرار
                      SizedBox(
                        width: double.infinity,
                        child: Checkbutton(
                          onTap: () {
                            controller.gotosuccesreset();
                          },
                          buttonName: 'Reset Password',
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
      ),
    );
  }
}
