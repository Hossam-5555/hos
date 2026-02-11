import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/countofproduct.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/description.dart';

class Itemsdetailes extends StatelessWidget {
  const Itemsdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    // تم استخدام GetBuilder لضمان تحديث الصفحة عند تغيير الحالة
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4DB), // لون الخلفية (البيج)
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(title: " Details", herotag: ""),
      ),
      body: GetBuilder<Itemdetailscontroller>(
        builder: (controller) {
          final item = controller.itemsmodel;
          return Stack(
            // الـ Stack هنا فقط لطبقة الاحتفال العائمة، التصميم بالداخل Column
            children: [
              Column(
                children: [
                  // 1. الجزء العلوي (الصورة)
                  SizedBox(
                    height: Get.height * 0.38, // 38% من الشاشة للصورة
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        child: Hero(
                          tag: '${item.itemsId}',
                          child: Image.network(
                            "${LinkApi.imageitems}/${item.itemsImage!}",
                            height: Get.height * 0.35,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. الجزء السفلي (التفاصيل)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // الشعار العائم (Hot Product) باستخدام التحريك للأعلى
                          Transform.translate(
                            offset: const Offset(
                              0,
                              -25,
                            ), // رفعه للأعلى ليتداخل مع الصورة
                            child: _buildHotProductBadge(),
                          ),

                          // تفاصيل المنتج
                          Text(
                            item.itemsName ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.itemsDesc ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                "${(double.parse(item.itemspricediscount.toString()).toStringAsFixed(2))}\$",
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // التقييم والعداد
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: List.generate(
                                  4,
                                  (index) => const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Countofproduct(count: controller.itemcount),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // الوصف وزر عرض المزيد
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Description",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              TextButton(
                                onPressed: () => _showDescriptionSheet(context),
                                child: const Text(
                                  "See More",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "هذا وصف تفصيلي للمنتج يوضح كل الخصائص والمميزات...\nGood product, perfect for daily use.",
                            style: TextStyle(height: 1.6),
                            maxLines: 2,
                          ),

                          const Spacer(),

                          // الزر السفلي
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: SizedBox(
                                width: 300,
                                height: 50,
                                child: MaterialButton(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  onPressed: () {
                                    if (controller.itemcount == 0) {
                                      Get.snackbar(
                                        "تنبيه",
                                        "لا يوجد عنصر في السله",
                                      );
                                    } else {
                                      controller.isadded = true;
                                      controller.addtocart(
                                        controller.itemsmodel.itemsId!
                                            .toString(),
                                        controller.itemcount,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    " Buy Now",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // // 3. طبقة الاحتفال (تظهر فقط عند الإضافة)
              if (controller.isadded)
                Positioned(
                  child: IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Animationforstatus(
                            animationPath: Imageasset.celebiration,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ودجت الشعار العائم
  Widget _buildHotProductBadge() {
    return Transform.rotate(
      angle: -math.pi / 30.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: const Color(0xFF595959).withAlpha(50),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.rocket_launch_sharp, size: 20),
                SizedBox(width: 8),
                Text(
                  "Hot product",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // نافذة الوصف المنبثقة
  void _showDescriptionSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[200],
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: Get.height * 0.6,
        child: SingleChildScrollView(
          child: SmartDescriptionView(
            rawText:
                "هذا وصف تفصيلي للمنتج يوضح كل الخصائص والمميزات \n Good product ,perfect for daily use مع شرح كامل...",
          ),
        ),
      ),
    );
  }
}
