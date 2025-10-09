// import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homescreencontroller.dart';
import 'package:hos/veiw/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/screen/settings/settings.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(Homescreencontroller());
    // الحصول على حجم الشاشة
    // final size = MediaQuery.of(context).size;
    // final height = size.height;
    //  final width = size.width;

    return GetBuilder<Homescreencontroller>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          leading: Padding(
            // الخطوة 1: إضافة هامش قياسي ليكون بعيدًا عن الحافة
            padding: const EdgeInsets.only(left: 16.0),
            child: Hero(
              // الخطوة 2: جعل الـ Hero يلتف حول الدائرة بالكامل
              tag: 'settengtag',
              child: Container(
                width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    // إضافة ظل خفيف ليعطي عمقاً
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Get.to(
                      () => Settings(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 800),
                    );
                  },
                  icon: Icon(Icons.settings),
                  iconSize: 24, // الخطوة 4: تحديد حجم قياسي للأيقونة
                  splashRadius: 24, // لجعل تأثير الضغط لا يخرج عن الدائرة
                ),
              ),
            ),
          ),
          actions: [
            // هذا هو الويدجت الخاص بالزر نفسه
            Padding(
              // لإضافة مسافة قياسية من حافة الشاشة اليمنى
              padding: const EdgeInsets.only(right: 16.0),
              child: Hero(
                tag: "carttag", // تأكد أن هذا الـ tag فريد
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.to(
                        () => ShoppingCartPage(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 800),
                      );
                    },
                    icon: Icon(Icons.shopping_cart_outlined), // أيقونة أنسب
                    iconSize: 24, // حجم قياسي للأيقونة
                    splashRadius: 24, // ليبقى تأثير الضغط داخل الدائرة
                  ),
                ),
              ),
            ),
          ],
          title: Text(controller.Appbartitle[controller.Currentpage][0]),
        ),
        floatingActionButton: Buttomappbar(),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        body: Padding(
          padding: const EdgeInsets.all(5),
          child: controller.pages.elementAt(controller.Currentpage),
        ),
      ),
    );
  }
}
