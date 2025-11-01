import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/auth/forgetpass/successresetcontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Succesresetpass extends StatelessWidget {
  const Succesresetpass({super.key});

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    Successresetcontroller controller = Get.put(Successresetcontroller());
    return Scaffold(
      appBar: AppBar(title: Text('Sccess')),
      body: Column(
        children: [
          Center(
            child: Text(
              'تم إعادة تعيين كلمة المرور بنجاح',
              style: TextStyle(fontSize: 24),
            ),
          ),
          // Spacer(),
                    SizedBox(height: height*0.75,),

          Checkbutton(buttonColor:Appcolor.primaryColor,width: width*0.40,
            onTap: () {
              controller.gotologin();
            },
            buttonName: "Go To Login",
          ),
        ],
      ),
    );
  }
}
