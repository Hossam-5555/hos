import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/conistant/linkApi.dart';

/// ================= Categories List =================
class ListCategories extends GetView<HomepageController> {
  const ListCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      itemBuilder: (context, index) {
        final cat = controller.categories[index];
        return CategoryItem(
          index: index,
          name: cat.categoriesName ?? "",
          imageUrl:
              "${LinkApi.imagecategories}/${cat.categoriesImage}",
        );
      },
    );
  }
}

/// ================= Category Item =================
class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.index,
    required this.name,
    required this.imageUrl,
  });

  final int index;
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      builder: (controller) {
        return InkWell(
          onTap: () {
            controller.gotoitems(
              controller.categories,
              index,
              controller.categories[index].categoriesId!,
            );
          },
          child: Container(
            width: 80,
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔥 Circle Image
                Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        const Color.fromARGB(255, 146, 146, 146)
                            .withAlpha(35),
                  ),
                  child: SvgPicture.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    placeholderBuilder: (_) =>
                        const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),

                const SizedBox(height: 4),

                /// 🔥 Category Name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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