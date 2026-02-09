import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';

class Buttom extends StatelessWidget {
  const Buttom({super.key});

  @override
  Widget build(BuildContext context) {
    Itemdetailscontroller itemdetailscontroller = Get.put(
      Itemdetailscontroller(),
    );
    return Container(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          if (itemdetailscontroller.itemcount == 0) {
            Get.rawSnackbar(
              message: "لا  يوجد عنصر في السلة",
              isDismissible: true,
              duration: Duration(seconds: 2),
              overlayBlur: 0, // لا تضع غبش خلفها لكي لا تعطل المستخدم
            );
          } else {
            itemdetailscontroller.isadded = true;
            itemdetailscontroller.addtocart(
              itemdetailscontroller.itemsmodel.itemsId!.toString(),
              itemdetailscontroller.itemcount,
            );
          }
        },
        child: const Text(
          " Buy Now",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
