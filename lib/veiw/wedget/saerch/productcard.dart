import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hos/data/model/itemsmodel.dart';

// ignore: must_be_immutable
class SearchProductCard extends StatelessWidget {
  SearchProductCard({super.key, this.onTap, required this.item});
  void Function()? onTap;
  ItemsModel item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            color: Colors.grey.withAlpha(50),
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Row(
          children: [
            // 🖼️ صورة المنتج
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF), // مركز الإضاءة الأبيض المشع
                    Color(0xFFF2F4F7), // البلاتينيوم الناعم
                    Color(0xFFD0D5DD), // الأطراف الفضية الراقية
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  imageUrl: "${item.itemsImage}",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.broken_image, color: Colors.grey.shade400),
                  fit: BoxFit.contain, // contain أحسن عشان الصورة متتقصش
                ),
              ),
            ),
            const SizedBox(width: 15),
            // 📝 تفاصيل المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemsName ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${item.itemsPrice} ${"EGP".tr}',
                        style: TextStyle(
                          // fontSize: 15,
                          color: Colors.blue,
                          // fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        "4.5",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // أيقونة سهم صغير شيك في الآخر
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
