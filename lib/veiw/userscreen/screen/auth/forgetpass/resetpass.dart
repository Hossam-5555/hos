import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hos/controler/usercontroller/auth/forgetpass/resetpasscontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/functions/validinput.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Resetpass extends StatelessWidget {
  const Resetpass({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Resetpasscontroller());

    return Scaffold(
      appBar: AppBar(title: const Text('Resset Password')),
      body: GetBuilder<Resetpasscontroller>(
        builder: (controller) => Handlingdatrequest(
          statusrequest: controller.statusrequest,
          widget: Form(
            key: controller.formstate,
            child: Column(
              children: [
                Text(
                  'Add new password',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Container(
                  width: 350,
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: Textfealdauth(
                    valid: (val) {
                      return validInput(val!, 10, 30, "password");
                    },
                    hint: 'enter passWord',
                    textEditingController: controller.password,
                    suffixIcon: Icons.lock,
                  ),
                ),
                Container(
                  width: 350,
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: Textfealdauth(
                    valid: (val) {
                      return validInput(val!, 10, 30, "password");
                    },
                    suffixIcon: Icons.lock,
                    hint: ' re enter password',
                    textEditingController: controller.repassword,
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: Checkbutton(
                    onTap: () {
                      controller.gotosuccesreset();
                    },
                    buttonName: 'resset',
                    width: 300,
                    buttonColor: Colors.deepPurple,
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
