import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:hos/controler/admincontroller/Homecontroller.dart';

// ignore: must_be_immutable
class AdminHome extends StatelessWidget {
  AdminHome({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(adminHomecontroller());
    return Scaffold(
      appBar: AppBar(title: Text("Admin Page")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),

          children: [
            Center(
              child: MaterialButton(
                color: Colors.amber,
                elevation: 3,
                height: 100,
                minWidth: 100,
                child: Text("   categiries   "),
                onPressed: () {
                  controller.gotocategories();
                },
              ),
            ),
            Center(
              child: MaterialButton(
                color: Colors.amber,
                elevation: 3,
                height: 100,
                minWidth: 100,
                child: Text(" تستطيع تسجيل الخروج   "),
                onPressed: () {
                  // String id = myservisec.sharedPreferences.getString("id")!;
                  // FirebaseMessaging.instance.subscribeToTopic("users");
                  // FirebaseMessaging.instance.subscribeToTopic("users${id}");
                  // myservisec.sharedPreferences.clear();
                  // Get.offAndToNamed(Approute.login);
                },
              ),
            ),
         
         
          ],
        ),
      ),
    );
  }
}
