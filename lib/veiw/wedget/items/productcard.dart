import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:lottie/lottie.dart';

Widget productcard(ItemsModel items, void Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1. مربع الصورة بالخلفية الرمادية الفاتحة
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                // صورة المنتج
                Center(
                  child: Hero(
                    tag: '${items.id}',
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CachedNetworkImage(
                        imageUrl: items.itemsImage!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                          favController.chasngfav(items.id, isFav ? "0" : "1");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border_rounded,
                              color: isFav ? Colors.redAccent : Colors.black,
                              size: 20,
                            ),
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
        ),

        const SizedBox(height: 2),

        // وصف قصير (زي Oversized clean drip في الصورة) - تقدر تغيره للوصف الفعلي من الـ model
        Text(
          "${items.itemsDesc}", // يفضل تخليها: items.itemsDesc أو أي حقل مناسب عندك
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
            color: Colors.blue,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
