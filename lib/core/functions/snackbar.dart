import 'package:flutter/material.dart';

class AppSnackBar extends SnackBar {
  AppSnackBar({
    super.key,
    required String message,
    required Widget icon,
    super.action,
    super.duration = const Duration(seconds: 4),
  }) : super(
         behavior: SnackBarBehavior.floating,
         margin: EdgeInsets.symmetric(horizontal: 30),
         backgroundColor: Color(0xFF1C1C22),
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
