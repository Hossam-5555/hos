import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});
  Myservisec myservisec = Get.put(Myservisec());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Admin page"),
          Center(
            child: MaterialButton(
              color: Colors.amber,
              elevation: 3,
              height: 100,
              child: Text(" تستطيع تسجيل الخروج ايها العرص "),
              onPressed: () {
                String id = myservisec.sharedPreferences.getString("id")!;
                FirebaseMessaging.instance.subscribeToTopic("users");
                FirebaseMessaging.instance.subscribeToTopic("users${id}");
                myservisec.sharedPreferences.clear();
                Get.offAndToNamed(Approute.login);
              },
            ),
          ),
        ],
      ),
    );
  }
}
