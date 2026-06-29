import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Icon icon,{SnackBarAction? s}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(action: s,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      backgroundColor: Colors.grey.shade600,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
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
