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
            Get.snackbar(
              "لا يوج عنصر",
              "     ادخل الكميه لكي تستطيع الشراء",
              backgroundColor: const Color.fromARGB(
                255,
                242,
                245,
                242,
              ).withAlpha(204), // 0.8 * 255 = 204
              colorText: const Color.fromARGB(255, 0, 0, 0),
              duration: const Duration(seconds: 1),
            );
          } else {
            itemdetailscontroller.isadded=true;
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
