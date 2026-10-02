import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/controler/usercontroller/home/homescreen_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/shoppage/carditem.dart';
import 'package:hos/veiw/wedget/shoppage/coubone.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<CartController>();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: GetBuilder<CartController>(
        builder: (controller) {
          return HandlingDataView(
            emptyStyle: EmptyStateStyle.style2,
            imagePath: Imageasset.emptycart,
            message: "Start shopping now".tr,
            statusrequest: controller.statusrequest,
            mediaType: HandlingMediaType.svgImage,
            mode: HandlingMode.fullScreen,
            widget: Column(
              children: [
                // ================= الجزء العلوي الذكي =================
                GetBuilder<Homescreencontroller>(
                  builder: (c) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            offset: Offset(0, 2),
                            blurStyle: BlurStyle.outer,
                            color: Colors.black.withAlpha(20),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: Theme.of(context).cardColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      // margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. الجزء المتغير (الكوبون والتفاصيل) - يختفي وينكمش عند السكرول
                          AnimatedAlign(
                            alignment: AlignmentGeometry.topCenter,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInSine,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: c.upordown ? 1.0 : 0.0,
                              child: c.upordown
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // SizedBox(
                                        //   height: (height * 0.015).clamp(
                                        //     8.0,
                                        //     16.0,
                                        //   ),
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Titles(title: "Order Details".tr),
                                          ],
                                        ),
                                        SizedBox(
                                          height: (height * 0.05).clamp(
                                            8.0,
                                            16.0,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                'Subtotal'.tr,
                                                style: TextStyle(
                                                  fontSize: (width * 0.04)
                                                      .clamp(14.0, 18.0),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${controller.totalprice}${"EGP".tr}',
                                              style: TextStyle(
                                                fontSize: (width * 0.045).clamp(
                                                  16.0,
                                                  22.0,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: (height * 0.05).clamp(
                                            8.0,
                                            16.0,
                                          ),
                                        ),
                                        controller.couponediscount <= 0
                                            ? Coubone(
                                                onChanged: (val) {
                                                  controller.havecoupone(val);
                                                },
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      'Discount'.tr,
                                                      style: TextStyle(
                                                        fontSize: (width * 0.04)
                                                            .clamp(14.0, 18.0),
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${controller.couponediscount} %',
                                                    style: TextStyle(
                                                      fontSize: (width * 0.045)
                                                          .clamp(16.0, 22.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        Divider(
                                          height: (height * 0.02).clamp(
                                            20.0,
                                            35.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),

                          // 2. الجزء الثابت دايماً (السعر الكلي + زر الـ Checkout)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total price'.tr,
                                style: TextStyle(
                                  fontSize: (width * 0.040).clamp(18.0, 24.0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 35,
                                child: GetBuilder<CartController>(
                                  builder: (controller) =>
                                      TweenAnimationBuilder<double>(
                                        tween: Tween<double>(
                                          begin: controller.totalprice,
                                          end:
                                              controller.totalprice -
                                              (controller.totalprice *
                                                  controller.couponediscount /
                                                  100),
                                        ),
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeOut,
                                        builder: (context, value, child) {
                                          return Text(
                                            '${value.toStringAsFixed(0)}${"EGP".tr}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: (width * 0.05).clamp(
                                                20.0,
                                                26.0,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          SizedBox(
                            width: width * 0.9,
                            child: Checkbutton.widget(
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Checkout'.tr,
                                    style: TextStyle(
                                      fontSize: (width * 0.040).clamp(
                                        16.0,
                                        22.0,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              width: width * 0.8,
                              buttonName: 'Checkout'.tr,
                              onTap: () {
                                controller.data.isNotEmpty
                                    ? controller.gotochechout()
                                    : Get.snackbar(
                                        "السلة فارغة",
                                        "لا يمكن تنفيذ العملية",
                                      );
                              },
                              buttonColor: Colors.black,
                              statusrequest: Statusrequest.none,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: height * 0.01),
                // =========================================================
                Expanded(
                  child: ListView.builder(
                 
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                    ),
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                      final item = controller.data[index];
                      bool isdark = context.isDarkMode ? true : false;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: buildCartItemCard(
                          context,
                          item,
                          controller,
                          index,
                          isdark,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
