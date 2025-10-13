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
        // selected: index == 0 ? true : false,
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
    // required this.selected,
    this.icon,
    required this.catig,
  });
  // final bool selected;
  IconData? icon;
  final int i;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      builder: (contriller) {
        return InkWell(
          onTap: () {
            contriller.gotoitems(contriller.categories, i, catig.categoriesId!);
          },
          child: Container(
            height: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: 70,
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent[100],
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                Text(
                  catig.categoriesName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
