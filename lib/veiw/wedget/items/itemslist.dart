import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/categoriesmodel.dart';

// ignore: must_be_immutable
class ListCatigoriesItem extends GetView<ItemsControler> {
  const ListCatigoriesItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemsControler>(
      builder: (controller) => ListView.builder(
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final catmodel = controller.categories[index];
          final icon = "${LinkApi.imagecategories}/${catmodel.categoriesImage}";
          return BuildCategoryItems(
            catmodel: catmodel,
            i: index,
            urlIcon: icon,
          );
        },
      ),
    );
  }
}

class BuildCategoryItems extends StatelessWidget {
  final categoriesmodel catmodel;
  final int i;
  final String urlIcon;

  const BuildCategoryItems({
    super.key,
    required this.catmodel,
    required this.i,
    required this.urlIcon,
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
            margin: const EdgeInsets.only(right: 9),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:  Colors.grey.withAlpha(60),border: Border.all(
                color: selected ? Colors.black : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.all(8),
                  child: SvgPicture.network(
                    urlIcon,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  catmodel.categoriesName ?? '',
                  style: TextStyle(
                    color: selected ? const Color.fromARGB(255, 56, 56, 56) : const Color.fromARGB(179, 148, 146, 146),
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
