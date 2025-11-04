import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/veryficodesignup.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';

class Veryfisign extends StatelessWidget {
  const Veryfisign({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(veryfisigncontroler());
    return Scaffold(
      appBar: AppBar(title: const Text('Veryficode')),
      body: SingleChildScrollView(
        child: GetBuilder<veryfisigncontroler>(
          builder: (controller) => Handlingdatrequest(
            statusrequest: controller.statusrequest,
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.start, // عموديًا
              crossAxisAlignment: CrossAxisAlignment.center, // أفقيًا
              children: [
                SizedBox(height: 30),
                Text(
                  'Check Code',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 100,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'please enter the digit code send to\n ${controller.email} ....',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                Container(margin: EdgeInsets.only(bottom: 20),
                  child: OtpTextField(
                    numberOfFields: 5,enabledBorderColor: Colors.black,
                    fieldWidth: 40.0,
                    borderRadius: BorderRadius.circular(30),
                    borderColor: Color.fromARGB(255, 0, 0, 0),
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {},
                    onSubmit: (String verificationCode) {
                      controller.gotoSuccessignup(verificationCode);
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: Text("Verification Code"),
                      //       content: Text('Code entered is $verificationCode'),
                      //     );
                      //   },
                      // );
                    },
                    // end onSubmit
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.resendcode();
                  },
                  child: Center(
                    child: Text(
                      "RESEND",
                      style: TextStyle(
                        fontSize: 20,
                        color: Appcolor.blackblue,
                        fontWeight: FontWeight.bold,
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
