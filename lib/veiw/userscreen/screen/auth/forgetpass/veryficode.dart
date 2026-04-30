import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/veryficodecontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';

class Veryficode extends StatelessWidget {
  const Veryficode({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VeryFiControler());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Code'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Appcolor.black,
      ),
      body: SafeArea(
        child: GetBuilder<VeryFiControler>(
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
                    SizedBox(height: size.height * 0.03),

                    /// 🟢 عنوان
                    Text(
                      'Verify Code',
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: Appcolor.black,
                          ),
                    ),

                    SizedBox(height: 10),

                    /// 🟢 وصف
                    Text(
                      'Enter the 5-digit code sent to your email',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                    ),

                    SizedBox(height: size.height * 0.06),

                    /// 🟢 OTP
                    OtpTextField(
                      numberOfFields: 5,
                      fieldWidth: size.width * 0.12,
                      borderRadius: BorderRadius.circular(12),
                      borderColor: Appcolor.black,
                      enabledBorderColor: Colors.grey.shade400,
                      focusedBorderColor: Appcolor.black,
                      showFieldAsBox: true,
                      cursorColor: Appcolor.black,

                      onCodeChanged: (String code) {},

                      onSubmit: (String verificationCode) {
                        controller.chekCode(verificationCode);
                      },
                    ),

                    SizedBox(height: size.height * 0.05),

                    /// 🟢 إعادة إرسال
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            // controller.resendCode(); // اعملها في الكنترولر
                          },
                          child: Text(
                            "Resend",
                            style: TextStyle(
                              color: Appcolor.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
