import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
            width: width * 0.70, // ← متجاوب يعرض 85% من الشاشة
            height: 75, // ← ارتفاع ثابت ومناسب
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 236, 232, 229).withAlpha(180),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(60),
                    offset: const Offset(0, 0.1),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(controller.pages.length, (index) {
                  final bool isSelected = controller.Currentpage == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changpage(index),
                      child: AnimatedContainer(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: isSelected ? 65 : 48,
                        height: isSelected ? 65 : 48,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              controller.appbartitle[index][1],
                              height: 24,
                              width: 24,
                            ),
                            // if (isSelected)
                            Text(
                              controller.appbartitle[index][0],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
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
    );
  }
}
