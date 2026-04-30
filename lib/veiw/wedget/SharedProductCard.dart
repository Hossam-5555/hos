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
    final size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            color: Colors.grey.withAlpha(50),
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. الصورة
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100], // ✅ لون رمادي فاتح لخلفية الصورة
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ), // ✅ زوايا دائرية لحامل الصورة
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
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),

            /// 3. التقييم
            Row(
              children: [
                Icon(Icons.star_rounded, size: w * 0.035, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            /// 4. السعر + الأكشن (متغير حسب الصفحة)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "$price${"EGP".tr}",
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                ),
                SizedBox(width: 4),
                actionButton, // 👈 هنا هيتعرض الزرار اللي هتبعتهوله
              ],
            ),
          ],
        ),
      ),
    );
  }
}
