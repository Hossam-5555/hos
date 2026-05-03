import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';

class Buttomappbar extends GetView<Homescreencontroller> {
  const Buttomappbar({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GetBuilder<Homescreencontroller>(
      builder: (controller) => AnimatedSlide(
        offset: controller.upordown ? Offset.zero : const Offset(0, 2),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInQuad,
        child: IgnorePointer(
          ignoring: !controller.upordown,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: width * 0.70, // ← متجاوب يعرض 85% من الشاشة
            height: 75, // ← ارتفاع ثابت ومناسب
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[150],
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey.withAlpha(50)),
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
                        width: isSelected ? 65 : 48,
                        height: isSelected ? 65 : 48,
                        decoration: BoxDecoration(
                          color: isSelected ?  Colors.blueAccent.withAlpha(50) : null,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            index == 3
                                ? ClipOval(
                                    child: SizedBox(
                                      height: isSelected ? 30 : 25,
                                      width: isSelected ? 30 : 25,
                                      child: Image.asset(
                                        Imageasset.twetter,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(color:  isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                    controller.appbartitle[index][1],
                                    height: isSelected ? 25 : 22,
                                    width: isSelected ? 25 : 22,
                                  ),
                            // if (isSelected)
                            Text(
                              controller.appbartitle[index][0],
                              style: TextStyle(
                                fontSize: isSelected ? 12 : 10,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w200,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
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
