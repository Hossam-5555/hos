import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future<bool> appexitAlert() {
  Get.defaultDialog(
    title: 'تنبيه',
    middleText: "هل تريد الخروج حقا 🥲",
    actions: [
      ElevatedButton(
        onPressed: () {
          exit(0);
        },
        child: Text('Confairm'),
      ),
      ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text('Cancel'),
      ),
    ],
  );

  return Future.value(true);
}
