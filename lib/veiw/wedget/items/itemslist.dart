import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class BuildCategoryItems extends StatelessWidget {
  final categoriesmodel catmodel;
  final int i;
  final String urlIcon;

  const BuildCategoryItems({
    super.key,
    required this.catmodel,
    required this.i,
    required this.urlIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemsControler>(
      builder: (controller) {
        final selected = controller.selecteditem == i;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(right: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => controller.changcat(i, catmodel.categoriesId!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [Color(0xff0F1729), Color(0xff1F2937)],
                      )
                    : null,
                color: selected ? null : Colors.grey.withAlpha(40),
                borderRadius: BorderRadius.circular(40),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: SvgPicture.network(
                      urlIcon,
                      colorFilter: selected
                          ? const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            )
                          : null,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    catmodel.categoriesName ?? '',
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}