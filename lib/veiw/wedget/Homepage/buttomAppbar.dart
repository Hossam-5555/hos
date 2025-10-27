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
        padding: const EdgeInsets.symmetric(vertical: 3),
        // ← أضفنا Container هنا ليكون هو المسؤول عن التموضع
        width: 290 ,
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
                color: const Color.fromARGB(255, 218, 219, 216).withAlpha(50),
                borderRadius: BorderRadius.circular(25),
             
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 66, 66, 66).withAlpha(60),
                    blurRadius: 5,
                    offset: const Offset(0, 1),
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
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOut,
                      width: isSelected ? 65 : 60,
                      height: isSelected ? 65 : 60,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.Appbartitle[index][1],
                        color:Appcolor.black,
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
