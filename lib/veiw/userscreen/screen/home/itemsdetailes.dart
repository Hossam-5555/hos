// import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/countofproduct.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/description.dart';
import 'package:lottie/lottie.dart';

class Itemsdetailes extends StatelessWidget {
  const Itemsdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;

    // متغير محلي سريع من GetX للتحكم في حالة عرض الوصف كاملاً أو اختصاره
    final RxBool isDescriptionExpanded = false.obs;
    Get.put(FavController());

    return GetBuilder<Itemdetailscontroller>(
      builder: (controller) {
        final item = controller.itemsmodel;
        return Scaffold(
          bottomNavigationBar: _buildBottomBar(controller),

          body: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: 40, // زيادة مسافة الأمان السفلية لجميع الشاشات
                ),
                children: [
                  // 1. صورة المنتج مع الشعار
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: h * 0.55, // متناسق ديناميكياً مع ارتفاع الشاشة
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
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
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          controller: controller.controller,
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
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                                Text(
                                  "4.8",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        h *
                                        0.018, // حجم خط مرن يتناسب مع الشاشة
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // السعر والخصم
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPriceSection(item),
                            SizedBox(
                              height: 50,
                              child: Transform.rotate(
                                angle: 0.20,
                                child: Lottie.asset(
                                  Imageasset.sale,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),

                        // 🔥 تعديل قسم الوصف: التحكم في العرض هنا داخلياً وإلغاء الـ BottomSheet
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Description".tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () => isDescriptionExpanded
                                  .toggle(), // يعكس الحالة مباشرة عند الضغط
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Obx(
                                  () => Text(
                                    isDescriptionExpanded.value
                                        ? "See less".tr
                                        : "See more".tr,
                                    style: TextStyle(
                                      color: Appcolor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // يظهر الـ SmartDescriptionView كاملة عند التمديد، أو نصاً مختصراً بـ 3 أسطر
                        Obx(
                          () => isDescriptionExpanded.value
                              ? SmartDescriptionView(
                                  rawText: "${item.itemsDesc}",
                                )
                              : Text(
                                  "${item.itemsDesc}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(height: 1.4),
                                ),
                        ),
                        const SizedBox(
                          height: 40,
                        ), // مساحة إضافية لتسهيل السكرول فوق الـ bottomNavigationBar
                      ],
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                top: 40,
                child: SizedBox(
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtonCircle(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                                  margin: const EdgeInsets.all(10),
                                  width: controller.curentpage == index
                                      ? 15
                                      : 5,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Appcolor.primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), // مسافة ديناميكية بين الزرين
                      GetBuilder<FavController>(
                        builder: (favController) {
                          bool isFav = favController.isfavorite[item.id] == "1";
                          return GestureDetector(
                            onTap: () {
                              favController.favmanget(item.id!);
                              favController.chasngfav(
                                item.id,
                                isFav ? "0" : "1",
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                  shape: CircleBorder(),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border_rounded,
                                      color: isFav
                                          ? Colors.redAccent
                                          : Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // if (item.itemsDiscount.toString() != "0.00")
              //   PositionedDirectional(
              //     bottom: h * 0.33, // متناسق ديناميكياً مع ارتفاع الشاشة
              //     end: 10,
              //     child: SizedBox(
              //       height: 50,
              //       child: Transform.rotate(
              //         angle: 0.20,
              //         child: Lottie.asset(
              //           Imageasset.sale,
              //           width: 50,
              //           height: 50,
              //           fit: BoxFit.fill,
              //         ),
              //       ),
              //     ),
              //   ),
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
            Flexible(child: Countofproduct(count: controller.itemcount)),
            const SizedBox(width: 10),
            Flexible(
              child: SizedBox(
                height: 55,
                child: GetBuilder<Itemdetailscontroller>(
                  builder: (controller) {
                    return Checkbutton(
                      statusrequest: controller.statusrequest,
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
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        if (discount > 0)
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 1,
            ),
          ),
      ],
    );
  }
}
