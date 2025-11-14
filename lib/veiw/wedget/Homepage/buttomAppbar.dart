import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/homescreencontroller.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';

class Buttomappbar extends GetView<Homescreencontroller> {
  const Buttomappbar({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GetBuilder<Homescreencontroller>(
      builder: (controller) => AnimatedSlide(
        offset: controller.upordown ? Offset.zero : const Offset(0, 2),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: IgnorePointer(
          ignoring: !controller.upordown,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: width * 0.85, // ← متجاوب يعرض 85% من الشاشة
            height: 75, // ← ارتفاع ثابت ومناسب
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(77),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      controller.pages.length,
                      (index) {
                        final bool isSelected =
                            controller.Currentpage == index;

                        return GestureDetector(
                          onTap: () => controller.changpage(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: isSelected ? 55 : 48,
                            height: isSelected ? 55 : 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                controller.Appbartitle[index][1],
                                height: isSelected ? 28 : 23,
                                width: isSelected ? 28 : 23,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
