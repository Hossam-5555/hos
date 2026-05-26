import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/shoppage/carditem.dart'; // تأكد من المسار
import 'package:hos/veiw/wedget/shoppage/coubone.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          return Handlingdataview(
            statusrequest: Statusrequest.none,
            widget: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    // ❌ تم إزالة الارتفاع الثابت ليأخذ الحاوية حجم العناصر تلقائياً
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, // هامش جانبي مرن
                      vertical: height * 0.02,
                    ),
                    child: Column(
                      // ✅ يجعل العمود يأخذ مساحة محتواه فقط لمنع التمدد غير المبرر
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // الإجمالي
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total price'.tr,
                              style: TextStyle(
                                // ✅ استخدام clamp لمنع الخط من التضخم أو التضاؤل بشكل مبالغ فيه
                                fontSize: (width * 0.04).clamp(14.0, 18.0),
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${controller.totalprice}${" EGP".tr}',
                              style: TextStyle(
                                fontSize: (width * 0.045).clamp(16.0, 22.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: (height * 0.015).clamp(8.0, 16.0)),

                        // الخصم
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
                        Divider(height: (height * 0.03).clamp(20.0, 35.0)),

                        Coubone(
                          onChanged: (val) {
                            controller.havecoupone(val);
                          },
                        ),

                        Divider(height: (height * 0.03).clamp(20.0, 35.0)),

                        // المجموع الكلي
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

                            /// 🔥 الحل هنا
                            SizedBox(
                              height: 35, // تثبيت الارتفاع للحفاظ على الأنيميشن
                              child: GetBuilder<CartController>(
                                builder: (controller) => TweenAnimationBuilder<double>(
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
                                        // جعله متجاوباً مع الحفاظ على الحجم التقريبي السابق (20)
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

                        SizedBox(height: (height * 0.025).clamp(16.0, 30.0)),

                        // زر إتمام الشراء
                        SizedBox(
                          width: double
                              .infinity, // يضمن أخذ الزر العرض المتاح بشكل مثالي
                          child: ElevatedButton(
                            onPressed: () {
                              controller.data.isNotEmpty
                                  ? controller.gotochechout()
                                  : Get.snackbar(
                                      "السلة فارغة", // تعديل إملائي بسيط
                                      "لا يمكن تنفيذ العملية",
                                    );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: (height * 0.015).clamp(
                                  12.0,
                                  20.0,
                                ), // تبطين مرن للزر
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80),
                              ),
                              textStyle: TextStyle(
                                fontSize: (width * 0.040).clamp(14.0, 18.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  // ✅ ربط الدائرة بعرض الشاشة مع وضع حد أقصى وأدنى لكي لا تتشوه
                                  height: (width * 0.1).clamp(40.0, 50.0),
                                  width: (width * 0.1).clamp(40.0, 50.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 54, 53, 53),
                                  ),
                                  child: Icon(
                                    Icons.shopify_outlined,
                                    color: Colors.white,
                                    size: (width * 0.06).clamp(
                                      20.0,
                                      28.0,
                                    ), // أيقونة متجاوبة
                                  ),
                                ),
                                Text('Proceed to Checkout'.tr),
                                const Icon(Icons.navigate_next_outlined),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                controller.data.isEmpty &&
                        controller.statusrequest != Statusrequest.loading
                    ? SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Animationforstatus(
                              animationPath: Imageasset.nodata,
                            ),
                            Text("go to shop "),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = controller.data[index];
                          return Padding(
                            // ✅ تم إضافة مسافة جانبية لكي لا تلتصق الكروت بحافة الشاشة
                            padding: EdgeInsets.only(
                              bottom: 10,
                              left: width * 0.04,
                              right: width * 0.04,
                            ),
                            child: buildCartItemCard(
                              context,
                              item,
                              controller,
                              index,
                            ),
                          );
                        }, childCount: controller.data.length),
                      ),

                // مسافة سفلية مرنة عشان العناصر ما تلزقش في الحافة أو في أزرار التنقل (Safe Area)
                SliverToBoxAdapter(child: SizedBox(height: height * 0.1)),
              ],
            ),
          );
        },
      ),
    );
  }
}
