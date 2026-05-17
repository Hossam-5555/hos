import 'dart:ui';

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
    // double h = size.height;
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
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        // height: 20,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(
                            76,
                          ), // ✅ طبقة شفافة فوق الصورة
                          borderRadius: BorderRadius.circular(20),
                        ), // ✅ نفس الزوايا
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: w * 0.030,
                                  color: const Color.fromARGB(
                                    255,
                                    214,
                                    156,
                                    79,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// 2. تفاصيل المنتج
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            /// 3. التقييم

            // const SizedBox(height: 6),

            /// 4. السعر + الأكشن (متغير حسب الصفحة)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
