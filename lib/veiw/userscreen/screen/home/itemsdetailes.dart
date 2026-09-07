// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/anmationbutton.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/countofproduct.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/description.dart';
import 'package:lottie/lottie.dart';

class Itemsdetailes extends StatelessWidget {
  const Itemsdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double h = size.height;
    final double w = size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final RxBool isDescriptionExpanded = false.obs;
    Get.put(FavController());

    return GetBuilder<Itemdetailscontroller>(
      builder: (controller) {
        final item = controller.itemsmodel;
        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0F0F0F)
              : const Color(0xFFF8F8F8),
          bottomNavigationBar: _buildBottomBar(controller, isDark),
          body: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  // ─── صورة المنتج ───
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: h * 0.48,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                          child: PageView.builder(
                            onPageChanged: controller.onimagechange,
                            itemCount: item.images!.length,
                            itemBuilder: (context, index) => Center(
                              child: Hero(
                                tag: '${item.id}',
                                child: CachedNetworkImage(
                                  imageUrl: item.images![index],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            controller: controller.controller,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ─── تفاصيل المنتج ───
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم المنتج + تقييم
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.itemsName ?? '',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "4.8",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    " (193+)",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // وصف قصير
                        Text(
                          item.itemsDesc?.split('.').first ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // السعر
                        _buildPriceSection(item),

                        const SizedBox(height: 20),

                        // ─── معلومات التوصيل ───
                        _buildInfoRow(isDark),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 1),
                        ),

                        // ─── Description ───
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Description".tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            InkWell(
                              onTap: () => isDescriptionExpanded.toggle(),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Obx(
                                  () => Text(
                                    isDescriptionExpanded.value
                                        ? "See less".tr
                                        : "More...".tr,
                                    style: TextStyle(
                                      color: Appcolor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => isDescriptionExpanded.value
                              ? SmartDescriptionView(
                                  rawText: "${item.itemsDesc}",
                                )
                              : Text(
                                  "${item.itemsDesc}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.6,
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade700,
                                  ),
                                ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 1),
                        ),

                        // ─── Often Order With ───
                        _buildOftenOrderWith(isDark),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),

              // ─── AppBar فوق الصورة ───
              PositionedDirectional(
                top: 30,
                child: SizedBox(
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtonCircle(),
                      // مؤشر الصور
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
                      ),
                      // زرار المفضلة
                      GetBuilder<FavController>(
                        builder: (favController) {
                          final isFav =
                              favController.isfavorite[item.id] == "1";
                          return FavoriteButton(
                            key: ValueKey(item.id),
                            isFav: isFav,
                            onTap: () {
                              favController.favmanget(item.id!);
                              favController.chasngfav(
                                item.id,
                                isFav ? "0" : "1",
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── معلومات التوصيل ───
  Widget _buildInfoRow(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          infoChip(Icons.local_shipping_outlined, "Free Delivery", isDark),
          verticalDivider(),
          infoChip(Icons.access_time_rounded, "20-25 min", isDark),
          verticalDivider(),
          infoChip(Icons.local_fire_department_outlined, "162 Kcal", isDark),
        ],
      ),
    );
  }

  Widget infoChip(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.white70 : const Color(0xFF555555),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white60 : const Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  Widget verticalDivider() {
    return Container(height: 35, width: 1, color: Colors.grey.withOpacity(0.2));
  }

  // ─── Often Order With ───
  Widget _buildOftenOrderWith(bool isDark) {
    // بيانات ثابتة مؤقتة
    final List<Map<String, String>> suggestions = [
      {'name': 'Cola', 'price': '\$1.50', 'image': Imageasset.twetter},
      {'name': 'Fries', 'price': '\$2.00', 'image': Imageasset.twetter},
      {'name': 'Salad', 'price': '\$3.00', 'image': Imageasset.twetter},
      {'name': 'Juice', 'price': '\$2.50', 'image': Imageasset.twetter},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Often order with",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              "See all >",
              style: TextStyle(
                fontSize: 13,
                color: Appcolor.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final s = suggestions[index];
              return Container(
                width: 90,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        s['image']!,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s['name']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      s['price']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Bottom Bar ───
  Widget _buildBottomBar(Itemdetailscontroller controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Flexible(child: Countofproduct(count: controller.itemcount)),
            const SizedBox(width: 12),
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 55,
                child: Checkbutton(
                  statusrequest: Statusrequest.none,
                  buttonColor: isDark
                      ? const Color.fromARGB(255, 82, 80, 80)
                      : Colors.black,
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
                  buttonName: "Add to Cart",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── السعر ───
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        if (discount > 0) ...[
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 1,
            ),
          ),
          const SizedBox(width: 8),
          Transform.rotate(
            angle: 0.20,
            child: Lottie.asset(
              Imageasset.sale,
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ],
    );
  }
}
