import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/checkemail_controller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CheckemailController());

    return Scaffold(
      appBar: AppBar(title: const Text('Forget Password')),
      body: GetBuilder<CheckemailController>(
        builder: (controller) => Handlingdatrequest(
          statusrequest: controller.statusrequest,
          widget: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // عموديًا
                crossAxisAlignment: CrossAxisAlignment.center, // أفقيًا
                children: [
                  Text(
                    'Check Email',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    width: 300,
                    child: Form(
                      key: controller.formstate,
                      child: Textfealdauth(
                        valid: (val) {
                          return validInput(val!, 10, 30, "email");
                        },
                        textEditingController: controller.email,
                        suffixIcon: Icons.email_sharp,
                        hint: 'Enter your Email',
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Checkbutton(
                    onTap: () {
                      controller.checkemail();
                    },
                    buttonName: 'Check',
                    width: 300,
                    buttonColor: Appcolor.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
