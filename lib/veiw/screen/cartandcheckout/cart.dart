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

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart "),
        leading: Padding(
          // الخطوة 1: إضافة هامش قياسي ليكون بعيدًا عن الحافة
          padding: const EdgeInsets.only(left: 8.0),
          child: Hero(
            // الخطوة 2: جعل الـ Hero يلتف حول الدائرة بالكامل
            tag: 'carttag',
            child: Container(
              width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
              height: 48,
              padding: EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  // إضافة ظل خفيف ليعطي عمقاً
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 24, // الخطوة 4: تحديد حجم قياسي للأيقونة
                splashRadius: 24, // لجعل تأثير الضغط لا يخرج عن الدائرة
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

                // 🔹 مكان الكوبون + زر Apply
                Coubone(),

                // 🔹 ملخص الطلب
                buildOrderSummary(controller: controller),
              ],
            ),
          );
        },
      ),
    );
  }
}
