import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homescreencontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';

class Buttomappbar extends GetView<Homescreencontroller> {
  const Buttomappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homescreencontroller>(
      builder: (controller) => Container(
        // ← أضفنا Container هنا ليكون هو المسؤول عن التموضع
        width: 270,
        height: 70,
        margin: const EdgeInsets.only(bottom: 20), // ← نقلنا الـ margin هنا
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          // نضيف هذا السطر لضمان قص التأثير بشكل صحيح
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: Container(
              // شيلنا العرض والارتفاع والهامش من هنا
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0).withAlpha(40),
                  width: 0.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(60),
                    blurRadius: 5,
                    offset: const Offset(-1, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(controller.pages.length, (index) {
                  final isSelected = controller.Currentpage == index;

                  return GestureDetector(
                    onTap: () {
                      controller.changpage(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isSelected ? 70 : 60,
                      height: isSelected ? 70 : 70,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == controller.Appbartitle.length - 1
                            ? 0
                            : 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Colors.transparent,
                        shape: BoxShape.circle,
                       
                      ),
                      child: Icon(
                        controller.Appbartitle[index][1],
                        color: isSelected
                            ? Appcolor.black
                            : Colors.white.withOpacity(0.7),
                        size: isSelected ? 30 : 26,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}