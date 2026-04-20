import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';

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
              controller.categories[index].id.toString(),
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
                  // padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(
                      255,
                      146,
                      146,
                      146,
                    ).withAlpha(35),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                  //  SvgPicture.network(
                  //   imageUrl,
                  //   fit: BoxFit.contain,
                  //   placeholderBuilder: (_) =>
                  //       const CircularProgressIndicator(strokeWidth: 2),
                  // ),
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
