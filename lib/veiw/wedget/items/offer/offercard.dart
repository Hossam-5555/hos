import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/offercontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:lottie/lottie.dart';

class Offercard extends GetView<Offercontroller> {
  final int index;
  const Offercard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // تم إزالة active لأنه غير مستخدم في الكود الأصلي
    return ItemList(index: index, items: controller.offerList[index]);
  }
}

class ItemList extends GetView<Offercontroller> {
  final Itemsmodel items;
  final int index;

  // قمت بإزالة active لأنه لم يكن مستخدماً ويسبب تحذير must_be_immutable
  const ItemList({super.key, required this.items, required this.index});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // تعديل بسيط في الأبعاد لتكون أكثر تناسقاً
    final cardWidth = screenWidth * 0.42;
    final cardHeight = cardWidth * 1.4;

    // افتراض للتقييم في حال عدم وجوده في الموديل (يمكنك استبداله بقيمة حقيقية)
    final double rating = 4.5;

    return GestureDetector(
      onTap: () {
        // أضف هنا الانتقال لتفاصيل المنتج
      },
      child: Container(
        // تقليل المارجن قليلاً لاستغلال المساحة
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white, // خلفية بيضاء نظيفة
          borderRadius: BorderRadius.circular(16), // حواف أنعم
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // ظل أخف وأنعم
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              /// 1. صورة المنتج (الخلفية)
              Positioned.fill(
                child: Hero(
                  tag: '${items.itemsId}',
                  child: Image.network(
                    "${LinkApi.imageitems}/${items.itemsImage}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.broken_image_rounded,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    // إضافة loadingBuilder لتحسين تجربة المستخدم أثناء تحميل الصورة
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// 2. تدرج لوني داكن في الأسفل لجعل النص مقروءاً (أفضل من بوكس مصمت)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: cardHeight * 0.5, // يغطي نصف الكارد السفلي
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withAlpha(150), // أسود داكن في الأسفل
                        Colors.black.withAlpha(50), // أسود أخف في المنتصف
                        Colors.transparent, // شفاف في الأعلى
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              /// 3. زر المفضلة (أعلى اليمين)
              Positioned(
                top: 8,
                right: 8,
                child: GetBuilder<FavController>(
                  builder: (controller) {
                    bool isFav = controller.isfavorite[items.itemsId] == "1";
                    return Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // خلفية بيضاء شبه شفافة (Glass effect)
                        color: Colors.white.withAlpha(200),
                        boxShadow: [
                          BoxShadow(offset: const Offset(0, 0.3),
                            color: Colors.black.withAlpha(25), // 10% transparency
                            blurRadius: 8,
                            blurStyle: BlurStyle.outer, // ظل خارجي خفيف
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (isFav) {
                            controller.chasngfav(items.itemsId, "0");
                            controller.removefromfav(items.itemsId!.toString());
                          } else {
                            controller.chasngfav(items.itemsId, "1");
                            controller.addfav(items.itemsId!.toString());
                          }
                        },
                        icon: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : Colors.grey[800],
                          size: 22,
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// 4. علامة العرض (أعلى اليسار)
              Positioned(
                top: 0,
                left: 4,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  // تم إزالة التدوير (Rotation) ليكون شكله طبيعي أكثر
                  child: Lottie.asset(Imageasset.sale, fit: BoxFit.contain),
                ),
              ),

              /// 5. النصوص والمعلومات (في الأسفل)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// اسم المنتج
                      Text(
                        items.itemsName ?? "بدون اسم",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700, // خط أعرض قليلاً
                          fontSize: 10,
                          shadows: [
                            Shadow(color: Colors.black45, blurRadius: 2),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// السعر والتقييم في نفس السطر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// السعر (مميز بلون وحجم)
                          Text(
                            "${double.parse(items.itemspricediscount.toString()).toStringAsFixed(2)} ج.م",
                            style: const TextStyle(
                              // لون برتقالي/ذهبي لتمييز السعر
                              color: Color(0xFFFFC107),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),

                          /// التقييم (مدمج ومختصر)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "$rating",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
