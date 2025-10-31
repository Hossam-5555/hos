import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/checkout&cart/CartController.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/shoppage/carditem.dart';
import 'package:hos/veiw/wedget/shoppage/coubone.dart';
import 'package:hos/veiw/wedget/shoppage/samarywidget.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CartController());

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Hero(
            tag: 'carttag',
            child: Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                iconSize: 24,
                splashRadius: 24,
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: Column(
              children: [
                // 🔹 قائمة العناصر (تاخد كل المساحة المتاحة فوق)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                      final item = controller.data[index];
                      return buildCartItemCard(
                        context,
                        item,
                        controller,
                        index,
                      );
                    },
                  ),
                ),

                // 🔹 الكوبون
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.015,
                  ),
                  child:  Coubone(),
                ),

                // 🔹 ملخص الطلب (Responsive)
                BuildOrderSummary(controller: controller),
              ],
            ),
          );
        },
      ),
    );
  }
}
