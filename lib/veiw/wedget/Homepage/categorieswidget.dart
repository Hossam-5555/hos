import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homepage_controller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/data/model/categoriesmodel.dart';

// ignore: must_be_immutable
class listcatigories extends GetView<HomepageController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      itemBuilder: (context, index) => buildCategory(
        catig: categoriesmodel.fromJson(controller.categories[index]),

        icon: controller.categoresdinformation[index][1],
        selected: index == 0 ? true : false,
        i: index,
      ),
    );
  }
}

// ignore: must_be_immutable
class buildCategory extends StatelessWidget {
  final categoriesmodel catig;
  buildCategory({
    super.key,
    required this.i,
    required this.selected,
    this.icon,
    required this.catig,
  });
  final bool selected;
  IconData? icon;
  final int i;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      builder: (contriller) {
        return InkWell(
          onTap: () {
            contriller.gotoitems(contriller.categories, i,catig.categoriesId!);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: selected
                  ? Appcolor.primaryColor
                  : const Color.fromARGB(255, 171, 173, 173),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: selected ? Colors.white : Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          catig.categoriesName!,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
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
