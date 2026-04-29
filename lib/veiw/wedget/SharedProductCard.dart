import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SharedProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final double rating;
  final VoidCallback? onTap;
  final Widget actionButton; // 👈 ضفنا دي عشان نحط فيها (مسح، مفضلة، أو سلة)
  final double height; // ارتفاع ثابت للكارد
  const SharedProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    required this.actionButton, // 👈 مطلوبة هنا
    this.onTap,
    required this.height, // ممكن تعدلها لو حبيت
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. الصورة
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 146, 146, 146).withAlpha(35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// 2. تفاصيل المنتج
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),

            /// 3. التقييم
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            /// 4. السعر + الأكشن (متغير حسب الصفحة)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$price${"EGP".tr}",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                actionButton, // 👈 هنا هيتعرض الزرار اللي هتبعتهوله
              ],
            ),
          ],
        ),
      ),
    );
  }
}
