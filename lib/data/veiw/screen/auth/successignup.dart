import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/auth/successsigncontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Successignup extends StatelessWidget {
  const Successignup({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Successsigncontroller());
    return Scaffold(
      appBar: AppBar(title: Text('Sccess'), automaticallyImplyLeading: false),
      body: GetBuilder<Successsigncontroller>(
        builder: (controller) => Handlingdatrequest(
          statusrequest: controller.statusrequest,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'تم تسجيل الدخول بنجاح     ',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Expanded(flex: 1, child: Text("")),
                Container(
                  child: Checkbutton(
                    buttonColor: Appcolor.primaryColor,
                    onTap: () {
                      controller.gotologin();
                    },
                    buttonName: "Go To Login",
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
