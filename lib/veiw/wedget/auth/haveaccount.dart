import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hos/controler/auth/login_controller.dart';

class Haveaccount extends StatelessWidget {
  const Haveaccount({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());

    return InkWell(
      onTap: () {
        loginController.gotosignup();
      },
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Dont Have Accont ?"),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: TextButton(
                onPressed: () {
                  loginController.gotosignup();
                },
                child: Text(" Sign up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
