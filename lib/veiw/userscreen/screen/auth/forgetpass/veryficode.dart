import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/veryficodecontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';

class Veryficode extends StatelessWidget {
  const Veryficode({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(veryficontroler());
    return Scaffold(
      appBar: AppBar(title: const Text('Veryficode')),
      body: GetBuilder<veryficontroler>(
        builder: (controller) => Handlingdatrequest(
          statusrequest: controller.statusrequest,
          widget: SingleChildScrollView(
            child: Column(
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
                      'please enter the digit code send to ....',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                Container(
                  child: OtpTextField(enabledBorderColor: Colors.black,
                    numberOfFields: 5,
                    fieldWidth: 40.0,
                    borderRadius: BorderRadius.circular(30),
                    borderColor: Color(0xFF512DA8),
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {},
                    onSubmit: (String verificationCode) {
                      controller.chekCode(verificationCode);
                    },
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
