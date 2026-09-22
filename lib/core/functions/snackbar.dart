import 'package:flutter/material.dart';

class AppSnackBar extends SnackBar {
  AppSnackBar({
    super.key,
    required String message,
    required Widget icon,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
  }) : super(
         action: action,
         duration: duration,
         behavior: SnackBarBehavior.floating,
         backgroundColor: backgroundColor ?? Colors.grey.shade700,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
         content: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           mainAxisSize: MainAxisSize.min,
           children: [
             icon,
             const SizedBox(width: 10),
             Expanded(
               child: Text(
                 message,
                 style: const TextStyle(color: Colors.white, fontSize: 14),
               ),
             ),
           ],
         ),
       );
}

void showSnackBar(
  BuildContext context,
  String message,
  Widget icon, {
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(AppSnackBar(message: message, icon: icon, action: action));
}

String translatePayment(String val) {
  switch (val) {
    case "credit":
      return " credit ";
    case "cash":
      return "Cash";
    case "mobil":
      return " mobileWallet";
    default:
      return "غير معروف";
  }
}
