import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/veryficodecontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Veryficode extends StatelessWidget {
  const Veryficode({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VeryFiControler());
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final fieldEnabledColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return Scaffold(
      appBar: Appbarbackicon(title: "", herotag: "Verifi", selected: false),
      body: SafeArea(
        child: GetBuilder<VeryFiControler>(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.03),

                    Container(
                      height: 84,
                      width: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withAlpha(
                          isDark ? 40 : 25,
                        ),
                      ),
                      child: Icon(
                        Icons.mark_email_read_rounded,
                        size: 40,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    Text(
                      'Verify Code',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Enter the 5-digit code sent to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: subTextColor),
                    ),

                    SizedBox(height: size.height * 0.06),

                    OtpTextField(
                      numberOfFields: 5,
                      fieldWidth: size.width * 0.13,
                      borderRadius: BorderRadius.circular(14),
                      borderColor: fieldEnabledColor,
                      enabledBorderColor: fieldEnabledColor,
                      focusedBorderColor: AppColors.primaryColor,
                      showFieldAsBox: true,
                      cursorColor: AppColors.primaryColor,
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                      onCodeChanged: (String code) {
                        if (code.length == 5) {
                          FocusScope.of(context).unfocus();
                          controller.submit(code);
                        }
                      },
                      onSubmit: (String verificationCode) {
                        controller.submit(verificationCode);
                      },
                    ),

                    SizedBox(height: size.height * 0.05),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code?",
                          style: TextStyle(color: subTextColor, fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () {
                            // controller.resendCode();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Resend",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
