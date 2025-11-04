import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/shoppage/carditem.dart';
import 'package:hos/veiw/wedget/shoppage/coubone.dart';
import 'package:hos/veiw/wedget/shoppage/samarywidget.dart';

import '../../../wedget/appbarbackicon.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CartController());

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(title: "Cart", herotag: "carttag"),
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
                  child: Coubone(),
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
