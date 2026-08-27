import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
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
            imagePath: Imageasset.emptycart,
            message: "Start shopping now".tr,
            statusrequest: controller.statusrequest,
            mediaType: HandlingMediaType.svgImage,
            mode: HandlingMode.fullScreen,
            widget: Column(
              children: [
                SafeArea(
                  top: false,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black.withAlpha(50),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Coubone(
                          onChanged: (val) {
                            controller.havecoupone(val);
                          },
                        ),
                        SizedBox(height: (height * 0.015).clamp(8.0, 16.0)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sub Total',
                              style: TextStyle(
                                fontSize: (width * 0.04).clamp(14.0, 18.0),
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${controller.totalprice}${" EGP".tr}',
                              style: TextStyle(
                                fontSize: (width * 0.045).clamp(16.0, 22.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: (height * 0.015).clamp(8.0, 16.0)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discount'.tr,
                              style: TextStyle(
                                fontSize: (width * 0.04).clamp(14.0, 18.0),
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${controller.couponediscount} %',
                              style: TextStyle(
                                fontSize: (width * 0.045).clamp(16.0, 22.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: (height * 0.025).clamp(16.0, 30.0)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total price'.tr,
                              style: TextStyle(
                                fontSize: (width * 0.048).clamp(18.0, 24.0),
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
                                          '${value.toStringAsFixed(0)}${" EGP".tr}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: (width * 0.05).clamp(
                                              20.0,
                                              26.0,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Divider(height: (height * 0.03).clamp(20.0, 35.0)),

                        SizedBox(
                          width: width * 0.8,
                          child: Checkbutton.widget(
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopify,
                                  size: (width * 0.04).clamp(16.0, 20.0),
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: (width * 0.02).clamp(8.0, 12.0),
                                ),
                                Text(
                                  'Proceed to Checkout'.tr,
                                  style: TextStyle(
                                    fontSize: (width * 0.045).clamp(16.0, 22.0),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            width: width * 0.8,
                            buttonName: 'Proceed to Checkout'.tr,
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
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      width * 0.04,
                      12,
                      width * 0.04,
                      12,
                    ),
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                      final item = controller.data[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: buildCartItemCard(
                          context,
                          item,
                          controller,
                          index,
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
