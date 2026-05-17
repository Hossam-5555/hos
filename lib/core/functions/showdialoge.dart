import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static void show({
    required String title,

    required String message,

    required VoidCallback onConfirm,

    String confirmText = "تأكيد",

    String cancelText = "إلغاء",

    IconData icon = Icons.warning_rounded,

    Color color = Colors.orange,

    bool showCancel = true,
  }) {
    Get.defaultDialog(
      backgroundColor: const Color.fromARGB(255, 79, 79, 87),

      radius: 20,

      title: "",

      content: Column(
        children: [
          CircleAvatar(
            radius: 35,

            backgroundColor: color.withOpacity(.15),

            child: Icon(icon, size: 35, color: color),
          ),

          const SizedBox(height: 15),

          Text(
            title,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: color,

              fontSize: 22,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            message,

            textAlign: TextAlign.center,

            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              if (showCancel)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),

                    child: Text(cancelText),
                  ),
                ),

              if (showCancel) const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: color),

                  onPressed: () {
                    onConfirm();

                    Get.back();
                  },

                  child: Text(confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
