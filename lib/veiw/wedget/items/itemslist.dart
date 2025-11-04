import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/data/model/categoriesmodel.dart';

// ignore: must_be_immutable
class listcatigoriesitem extends GetView<ItemsControler> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemsControler>(
      builder: (controller) => ListView.builder(
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final catmodel = categoriesmodel.fromJson(
            controller.categories[index],
          );
          final icon = controller.categoresdinformation[index][1] as IconData;
          return buildCategoryitems(catmodel: catmodel, i: index, icon: icon);
        },
      ),
    );
  }
}

class buildCategoryitems extends StatelessWidget {
  final categoriesmodel catmodel;
  final int i;
  final IconData icon;

  const buildCategoryitems({
    super.key,
    required this.catmodel,
    required this.i,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemsControler>(
      builder: (controller) {
        final selected = controller.selecteditem == i;
        return InkWell(
          onTap: () => controller.changcat(i, catmodel.categoriesId!),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? Appcolor.primaryColor : Colors.grey[400],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: selected ? Colors.white : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  catmodel.categoriesName ?? '',
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.white70,
                    fontSize: 14,
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
