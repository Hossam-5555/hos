import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> appexitAlert() async {
  bool? shouldExit = await Get.defaultDialog<bool>(
    title: 'تنبيه',
    middleText: "هل تريد الخروج حقًا 🥲",
    barrierDismissible: false, // يمنع إغلاق النافذة بالنقر خارجها
    actions: [
      ElevatedButton(
        onPressed: () {
          Get.back(result: true); // ✅ يرجع true
        },
        child: const Text('تأكيد'),
      ),
      ElevatedButton(
        onPressed: () {
          Get.back(result: false); // ✅ يرجع false
        },
        child: const Text('إلغاء'),
      ),
    ],
  );

  return shouldExit ?? false;
}
