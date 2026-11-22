 import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/conistant/app_dimensions.dart';

Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.darkBorder,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.copyright,
              color: AppColors.darkCardSurface,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "HOS App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
              letterSpacing: 1.2,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "© 2026 All Rights Reserved",
            style: TextStyle(color: AppColors.grey, fontSize: AppDimensions.fontBodySmall),
          ),
        ],
      ),
    );
  }