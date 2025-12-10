import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/orderscreencontroller.dart';

class Buttomappbarorderadmin extends GetView<Orderscreencontroller> {
  const Buttomappbarorderadmin({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GetBuilder<Orderscreencontroller>(
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
                    color: const Color.fromARGB(255, 216, 216, 213).withAlpha(77),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 6,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(controller.pages.length, (index) {
                      final bool isSelected = controller.Currentpage == index;

                      return GestureDetector(
                        onTap: () => controller.changpage(index),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: AnimatedContainer(
                              margin: EdgeInsets.symmetric(
                                horizontal: !isSelected ? 10 : 0,
                              ),
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.fastEaseInToSlowEaseOut,
                              width: isSelected ? 70 : 70,
                              height: isSelected ? 70 : 70,
                              decoration: BoxDecoration(
                                border: isSelected
                                    ? Border.all(
                                        width: 0.1,
                                        color:  Colors.black.withAlpha(20),
                                      )
                                    : Border(),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  controller.orderscreen[index][1],
                                  height: isSelected ? 28 : 23,
                                  width: isSelected ? 28 : 23,
                                ),
                              ),
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
