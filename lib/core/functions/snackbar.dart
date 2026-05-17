import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message ) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
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