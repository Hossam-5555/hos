import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/homescreencontroller.dart';

class Buttomappbar extends GetView<driverHomecontroller> {
  const Buttomappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<driverHomecontroller>(
      builder: (controller) => AnimatedSlide(
        offset: controller.upordown ? Offset.zero : const Offset(0, 2),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: IgnorePointer(
          ignoring: !controller.upordown,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            // ← أضفنا Container هنا ليكون هو المسؤول عن التموضع
            width: 290,
            height: 80,
            margin: const EdgeInsets.only(bottom: 10), // ← نقلنا الـ margin هنا
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              // نضيف هذا السطر لضمان قص التأثير بشكل صحيح
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  // شيلنا العرض والارتفاع والهامش من هنا
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(77),
                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          125,
                          125,
                          125,
                        ).withAlpha(102),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(controller.driverpage.length, (index) {
                      final isSelected = controller.Currentpage == index;

                      return GestureDetector(
                        onTap: () {
                          controller.changpage(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeInOut,
                          width: isSelected ? 63 : 58,
                          height: isSelected ? 63 : 58,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            // علشان الأيقونة تكون في النص
                            child: SvgPicture.asset(
                              controller.driverAppbartitle[index][1],
                              height: isSelected
                                  ? 30
                                  : 25, // حجم الأيقونة لما تتحدد أو لا
                              width: isSelected ? 30 : 25,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
