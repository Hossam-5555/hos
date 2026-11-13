 import 'package:flutter/material.dart';

Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.copyright,
              color: Color(0xFF2962FF),
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "HOS App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.2,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "© 2026 All Rights Reserved",
            style: TextStyle(color: Colors.grey[400], fontSize: 11),
          ),
        ],
      ),
    );
  }