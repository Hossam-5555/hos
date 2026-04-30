import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:lottie/lottie.dart';

class ItemsCard extends GetView<ItemsControler> {
  // final int i;
  ItemsModel items;

  ItemsCard({super.key, required this.items});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.gotoitemsdatails(items);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 1. مربع الصورة بالخلفية الرمادية الفاتحة
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // color: const Color.fromARGB(
                //   255,
                //   146,
                //   146,
                //   146,
                // ).withAlpha(35), // لون رمادي فاتح مطابق للصورة
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // صورة المنتج
                  Center(
                    child: Hero(
                      tag: '${items.id}',
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.network(
                          "${items.itemsImage}",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                  ),

                  // علامة الخصم (لو موجودة)
                  if (items.itemsDiscount.toString() != "0.00")
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        height: 45,
                        child: Transform.rotate(
                          angle: 0.20,
                          child: Lottie.asset(Imageasset.sale),
                        ),
                      ),
                    ),

                  // أيقونة المفضلة
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GetBuilder<FavController>(
                      builder: (favController) {
                        bool isFav = favController.isfavorite[items.id] == "1";
                        return GestureDetector(
                          onTap: () {
                            favController.favmanget(items.id!);
                            favController.chasngfav(
                              items.id,
                              isFav ? "0" : "1",
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border_rounded,
                              color: isFav ? Colors.redAccent : Colors.black54,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10), // مسافة بين الصورة والنصوص
          /// 2. تفاصيل المنتج تحت الصورة
          // اسم المنتج
          Text(
            items.itemsName ?? "بدون اسم",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700, // خط عريض
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 2),

          // وصف قصير (زي Oversized clean drip في الصورة) - تقدر تغيره للوصف الفعلي من الـ model
          Text(
            "Built for movement", // يفضل تخليها: items.itemsDesc أو أي حقل مناسب عندك
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 6),

          // السعر
          Text(
            "${items.itemsPrice}${"Egp".tr}", // شلت الكسور عشان يبقى زي الصورة $39
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
