import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> appexitAlert() async {
  bool? shouldExit = await Get.defaultDialog<bool>(
    title: "Cloase",
    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
    middleText: "Are you  want to Cloase the App?".tr,
    radius: 16,
    cancel: TextButton(
      onPressed: () => Get.back(result: false),
      child: Text("Cancel".tr, style: TextStyle(color: Colors.grey.shade600)),
    ),
    confirm: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade500,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        Get.back(result: true);
      },
      child: Text("Cloase".tr, style: const TextStyle(color: Colors.white)),
    ),
  );

  return shouldExit ?? false;
}
