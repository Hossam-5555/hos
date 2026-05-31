import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppCupertinoDialog {
  static void show({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = "تأكيد",
    String cancelText = "إلغاء",
  }) {
    Get.dialog(
      transitionCurve: Curves.easeInCirc,
      transitionDuration: Duration(milliseconds: 300),
      CupertinoAlertDialog(insetAnimationCurve: Curves.linear,
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(cancelText),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
