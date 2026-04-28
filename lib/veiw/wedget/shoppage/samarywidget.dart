import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/veiw/wedget/shoppage/coubone.dart';

class BuildOrderSummary extends StatelessWidget {
  final CartController controller;
  const BuildOrderSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(
      height:controller.value==false? height * 0.40:height*0.45,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(width * 0.06),
          bottomLeft: Radius.circular(width * 0.06),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الإجمالي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total price'.tr,
                style: TextStyle(fontSize: width * 0.04, color: Colors.grey),
              ),
              Text(
                '${controller.totalprice}${" EGP".tr}',
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),

          // الخصم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount'.tr,
                style: TextStyle(fontSize: width * 0.04, color: Colors.grey),
              ),
              Text(
                '${controller.couponediscount} %',
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(height: height * 0.03),
          Coubone(),
          Divider(height: height * 0.03),
          // المجموع الكلي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total price'.tr,
                style: TextStyle(
                  fontSize: width * 0.048,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// 🔥 الحل هنا
              SizedBox(
                height: 40, // تثبيت الارتفاع
                child: GetBuilder<CartController>(
                  builder: (controller) => TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: controller.totalprice,
                      end:
                          controller.totalprice -
                          controller.totalprice *
                              controller.couponediscount /
                              100,
                    ),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Text(
                        '${value.toStringAsFixed(0)}${" EGP".tr}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: height * 0.025),

          // زر إتمام الشراء
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.data.isNotEmpty
                        ? controller.gotochechout()
                        : Get.snackbar(
                            "السلله  فارغه",
                            "لا يمكن تنفيذ العمليه",
                          );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: height * 0.005),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    textStyle: TextStyle(
                      fontSize: width * 0.040,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height * 0.06,
                        width: height * 0.06,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 54, 53, 53),
                        ),
                        child: const Icon(
                          Icons.shopify_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Text('Proceed to Checkout'.tr),
                      Icon(Icons.keyboard_arrow_right_outlined)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
