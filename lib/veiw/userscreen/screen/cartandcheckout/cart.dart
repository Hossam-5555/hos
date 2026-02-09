import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/shoppage/carditem.dart'; // تأكد من المسار
import 'package:hos/veiw/wedget/shoppage/samarywidget.dart'; // تأكد من المسار

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CartController());

    // final size = MediaQuery.of(context).size;
    // final double paddingHorizontal = size.width * 0.04;

    return Scaffold(
      body: GetBuilder<CartController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: CustomScrollView(
              physics: const BouncingScrollPhysics(), // سكرول مرن
              slivers: [
                // 1️⃣ قائمة المنتجات (بديل ListView)
                // إذا كانت القائمة فارغة، يمكن عرض رسالة، وإلا نعرض المنتجات

                // 3️⃣ ملخص الطلب (SliverToBoxAdapter)
                SliverToBoxAdapter(
                  child: BuildOrderSummary(controller: controller),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = controller.data[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: buildCartItemCard(
                        context,
                        item,
                        controller,
                        index,
                      ),
                    );
                  }, childCount: controller.data.length),
                ),

                // مسافة سفلية عشان العناصر ما تلزقش في الحافة
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          );
        },
      ),
    );
  }
}
