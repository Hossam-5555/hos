import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/countofproduct.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/description.dart';

class Itemsdetailes extends StatelessWidget {
  const Itemsdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    // نغلف الـ Scaffold بالكامل بـ GetBuilder عشان الـ BottomBar يتحدث مع العداد
    return GetBuilder<Itemdetailscontroller>(
      builder: (controller) {
        final item = controller.itemsmodel;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Appbarbackicon(title: "تفاصيل المنتج", herotag: ""),
          ),

          // ✨ التعديل الاحترافي: تثبيت زر الشراء والعداد في الأسفل دائماً
          bottomNavigationBar: _buildBottomBar(controller),

          body: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: 40,
                ), // مسافة قبل شريط الأسفل
                children: [
                  // 1. صورة المنتج مع الشعار
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: Get.height * 0.40,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF8F9FA,
                          ), // خلفية رمادي فاتح جداً تبرز الصورة
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Hero(
                            tag: '${item.itemsId}',
                            child: Image.network(
                              "${LinkApi.imageitems}/${item.itemsImage!}",
                              height: Get.height * 0.28,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: _buildHotProductBadge(),
                      ),
                    ],
                  ),

                  // 2. تفاصيل المنتج
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // التقييم واسم المنتج
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.itemsName ?? '',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "4.8",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ), // لو متاح تقييم
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // السعر والخصم
                        _buildPriceSection(item),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),

                        // الوصف
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Description".tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () => _showDescriptionSheet(context, item),
                              child: Text(
                                "See more",
                                style: TextStyle(
                                  color: Appcolor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${item.itemsDesc}",
                          style: TextStyle(
                            height: 1.6,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 3. طبقة الاحتفال (تظهر فقط عند الإضافة)
              if (controller.isadded)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Animationforstatus(
                        animationPath: Imageasset.celebiration,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // دوال بناء الواجهة
  // ==========================================

  Widget _buildBottomBar(Itemdetailscontroller controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

      child: SafeArea(
        child: Row(
          children: [
            // مكون العداد الخاص بك
            Countofproduct(count: controller.itemcount),

            // زر الإضافة للسلة
            Expanded(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // لون أسود فخم
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    if (controller.itemcount == 0) {
                      Get.snackbar(
                        "تنبيه",
                        "يرجى اختيار الكمية أولاً",
                        backgroundColor: Colors.red.shade50,
                        colorText: Colors.red,
                      );
                    } else {
                      controller.isadded = true;
                      Get.find<CartController>().addtocart(
                        controller.itemsmodel.itemsId!.toString(),
                        controller.itemcount,
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "إضافة للسلة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(Itemsmodel item) {
    double discount = double.tryParse(item.itemsDiscount.toString()) ?? 0;
    double price = double.tryParse(item.itemsPrice.toString()) ?? 0;
    double priceDiscount =
        double.tryParse(item.itemspricediscount.toString()) ?? 0;

    return Row(
      children: [
        Text(
          "\$${priceDiscount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 12),
        if (discount > 0)
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration:
                  TextDecoration.lineThrough, // الطريقة الاحترافية لشطب السعر
              decorationThickness: 1,
            ),
          ),
      ],
    );
  }

  Widget _buildHotProductBadge() {
    return Transform.rotate(
      angle: pi / -15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 18,
              color: Color.fromARGB(255, 199, 67, 5),
            ),
            SizedBox(width: 6),
            Center(
              child: Text(
                "Hot Product",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDescriptionSheet(BuildContext context, Itemsmodel item) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true, // عشان ياخد الارتفاع اللي محتاجه
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        height: Get.height * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "تفاصيل المنتج",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SmartDescriptionView(rawText: "${item.itemsDesc}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
