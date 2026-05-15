// import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/countofproduct.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/description.dart';

class Itemsdetailes extends StatelessWidget {
  const Itemsdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double h = size.height;
    // نغلف الـ Scaffold بالكامل بـ GetBuilder عشان الـ BottomBar يتحدث مع العداد
    return GetBuilder<Itemdetailscontroller>(
      builder: (controller) {
        final item = controller.itemsmodel;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Appbarbackicon(title: "product Details".tr, herotag: ""),
          ),

          // ✨ التعديل الاحترافي: تثبيت زر الشراء والعداد في الأسفل دائماً
          bottomNavigationBar: _buildBottomBar(controller),

          body: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: 20,
                ), // مسافة قبل شريط الأسفل
                children: [
                  // 1. صورة المنتج مع الشعار
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: Get.height * 0.45,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          // color: const Color(
                          //   0xFFF8F9FA,
                          // ), // خلفية رمادي فاتح جداً تبرز الصورة
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                        child: PageView.builder(
                          onPageChanged: (value) {
                            controller.onimagechange(value);
                          },
                          itemCount: item.images!.length,
                          itemBuilder: (context, index) => Center(
                            child: Hero(
                              tag: '${item.id}',
                              child: CachedNetworkImage(
                                imageUrl: item.images![index],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),

                          controller: controller.controller,
                        ),
                      ),
                      // dis != 0
                      //     ? Positioned(
                      //         bottom: 0,
                      //         left: 20,
                      //         child: _buildHotProductBadge(),
                      //       )
                      //     : SizedBox.shrink(),
                      Positioned(
                        top: h * 0.41,
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  item.images!.length,
                                  (index) => AnimatedContainer(
                                    margin: EdgeInsets.all(10),
                                    width: controller.curentpage == index ? 15 : 5,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Appcolor.primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    duration: Duration(milliseconds: 500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                maxLines: 2,
                                item.itemsName ?? '',
                                // style: const TextStyle(
                                //   fontSize: 22,
                                //   color: Colors.black,
                                //   fontWeight: FontWeight.bold,
                                //   height: 1.3,
                                // ),
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
                            Text("Description".tr),
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

                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // مكون العداد الخاص بك
            Flexible(child: Countofproduct(count: controller.itemcount)),
            SizedBox(width: 10),
            // زر الإضافة للسلة
            Flexible(
              child: SizedBox(
                height: 55,
                child: GetBuilder<Itemdetailscontroller>(
                  builder: (controller) {
                    return Checkbutton(
                      controller: controller,
                      buttonColor: Colors.black,
                      onTap: () {
                        if (controller.itemcount == 0) {
                          Get.snackbar(
                            "تنبيه",
                            "يرجى اختيار الكمية أولاً",
                            backgroundColor: Colors.red.shade50,
                            colorText: Colors.red,
                          );
                        } else {
                          Get.find<CartController>().addtocart(
                            controller.itemsmodel.id!,
                            controller.itemcount,
                          );
                        }
                      },
                      buttonName: "Add to Card",
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(ItemsModel item) {
    double discount = double.tryParse(item.itemsDiscount.toString()) ?? 0;
    double price = double.tryParse(item.itemsPrice.toString()) ?? 0;
    double priceDiscount =
        double.tryParse(item.priceAfterDiscount.toString()) ?? 0;

    return Row(
      children: [
        Text(
          "\$${priceDiscount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
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

  // Widget _buildHotProductBadge() {
  //   return Transform.rotate(
  //     angle: pi / -20,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade100,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.2),
  //             blurRadius: 8,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: const Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(
  //             Icons.local_fire_department_rounded,
  //             size: 18,
  //             color: Color.fromARGB(255, 199, 67, 5),
  //           ),
  //           SizedBox(width: 6),
  //           Center(
  //             child: Text(
  //               "Hot Product",
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showDescriptionSheet(BuildContext context, ItemsModel item) {
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
