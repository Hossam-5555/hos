import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/offercontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:lottie/lottie.dart';

class Offercard extends GetView<Offercontroller> {
  final int index;
  final ItemsModel items;

  Offercard({super.key, required this.index, required this.items});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // أضف هنا الانتقال لتفاصيل المنتج
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 1. مربع الصورة بالخلفية الرمادية الفاتحة (نفس شكل ItemsCard)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  146,
                  146,
                  146,
                ).withAlpha(35), // لون رمادي فاتح
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // صورة المنتج
                  Center(
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

                  // علامة العرض Lottie (أعلى اليسار)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Lottie.asset(Imageasset.sale, fit: BoxFit.contain),
                    ),
                  ),

                  // أيقونة المفضلة المينيمال (بدون خلفية بيضاء)
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
                              color: isFav ? Colors.redAccent : Colors.white,
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
          ),

          const SizedBox(height: 2),

          // وصف قصير (لو عندك وصف في الموديل يفضل تحطه هنا بدل النص الثابت)
          Text(
            "Special Offer", // ممكن تخليها items.itemsDesc
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
            "${double.parse(items.priceAfterDiscount.toString()).toStringAsFixed(0)} ${"EGP".tr}",
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
}
