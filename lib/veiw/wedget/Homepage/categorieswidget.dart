import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/conistant/linkApi.dart';

// ignore: must_be_immutable, camel_case_types
class listcatigories extends GetView<HomepageController> {
  const listcatigories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      itemBuilder: (context, index) => buildCategory(
        catname: controller.categories[index].categoriesName,
        urlimge:
            "${LinkApi.imagecategories}/${controller.categories[index].categoriesImage}",
        // selected: index == 0 ? true : false,
        i: index,
      ),
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class buildCategory extends StatelessWidget {
  buildCategory({
    super.key,
    required this.i,
    required this.catname,
    this.urlimge,
  });
  // final bool selected;
  String? urlimge;
  String? catname;
  final int i;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      builder: (contriller) {
        return InkWell(
          onTap: () {
            contriller.gotoitems(
              contriller.categories,
              i,
              contriller.categories[i].categoriesId!,
            );
          },
          child: SizedBox(
            height: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: 70,
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(
                      255,
                      146,
                      146,
                      146,
                    ).withAlpha(35),
                  ),
                  child: SvgPicture.network(
                    urlimge!,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                Text(
                  catname!,
                  style: TextStyle(
                    color: Colors.black,
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
