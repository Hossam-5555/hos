import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/orderscreencontroller.dart';
import 'package:hos/veiw/wedget/Homepage/buttomappbarorderadmin.dart';

class orderscreen extends StatelessWidget {
  const orderscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Get.put(Orderscreencontroller());

    return GetBuilder<Orderscreencontroller>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F6FA),

          title: Text(controller.orderscreen[controller.Currentpage][0]),
        ),

        // ================== تعديل الـ BottomAppbar ==================
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.012,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: width * 0.65, // عرض نسبي
              child: Buttomappbarorderadmin(),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // =============================================================
        body: controller.pages.elementAt(controller.Currentpage),
      ),
    );
  }
}
