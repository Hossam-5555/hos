import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/itemsmodel.dart';

class CurvedItemsView extends StatelessWidget {
  CurvedItemsView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return GetBuilder<HomepageController>(
      builder: (controller) {
        // 1. فحص أمان للقائمة فقط: إذا كانت القائمة فارغة، نعرض مؤشر تحميل
        if (controller.newArival.isEmpty) {
          return const SizedBox(
            height: 290,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. تعيين قيمة افتراضية للـ PageController إذا لم يتم تهيئته في الكنترولر بعد
        // استخدمنا (??) بحيث إذا كان null يأخذ النسخة الافتراضية
        final PageController pageController =
            controller.pageController ??
            PageController(initialPage: 0, viewportFraction: 0.5);

        return SizedBox(
          height: 290,
          child: PageView.builder(
            controller: pageController,
            itemCount: controller.newArival.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              ItemsModel items = controller.newArival[index];

              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 1.0;
                  double rotation = 0.0;
                  double translateY = 0.0;

                  // 3. التأكد من أن الكنترولر مرتبط بالواجهة قبل طلب القيم
                  if (pageController.hasClients &&
                      pageController.position.haveDimensions) {
                    // المتغير page قد يكون null في اللحظات الأولى، لذا نستخدم initialPage كبديل
                    double currentPage =
                        pageController.page ??
                        pageController.initialPage.toDouble();

                    // حساب الفرق بين مكان العنصر والصفحة الحالية
                    double diff = (index - currentPage);

                    // حساب التحجيم (Scale)
                    value = (1 - (diff.abs() * 0.25)).clamp(0.75, 1.0);

                    // حساب الدوران (Rotation)
                    rotation = diff * 0.1;

                    // حساب الإزاحة العمودية
                    translateY = 60 * (1 - value);
                  } else {
                    // القيمة الافتراضية عند بدء التشغيل قبل السكرول
                    if (index == pageController.initialPage) {
                      value = 1.0;
                      translateY = 0.0;
                    } else {
                      value = 0.75; // حجم العناصر الجانبية
                      translateY = 60 * (1 - value);
                    }
                  }

                  // 4. تطبيق التحويلات
                  return Transform.translate(
                    offset: Offset(0, translateY), // النزول للأسفل
                    child: Transform.scale(
                      scale: value, // التصغير والتكبير
                      child: Transform.rotate(
                        angle: rotation, // الدوران الخفيف
                        child: Opacity(
                          opacity: value.clamp(0.5, 1.0),
                          child: InkWell(
                            onTap: () {
                              controller.gotoitemsdetails(items);
                            },

                            // ❌ تم حذف ClipPath لاستخدام الزوايا الدائرية من BoxDecoration
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                border: Border.all(
                                  color: Colors.grey.withAlpha(50),
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                                
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 🖼 الصورة
                                  Container(
                                    height: height * 0.17,
                                    // المارجن الخاص بك جيد لعمل الهامش الداخلي
                                    margin: EdgeInsets.only(
                                      left: 17,
                                      right: 17,
                                      top: 17,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .grey[100], // ✅ لون رمادي فاتح لخلفية الصورة
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ), // ✅ زوايا دائرية لحامل الصورة
                                    ),
                                    // ✅ نستخدم ClipRRect لقص زوايا الصورة
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: items.itemsImage!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),

                                  // 🔹 الاسم والسعر وزر السلة
                                  // هذا الجزء كان منظماً بشكل جيد
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            width * 0.040, // تعديل بسيط للهوامش
                                        vertical: height * 0.012,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            items.itemsName ?? "بدون اسم",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: width * 0.038,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star_rounded,
                                                  size: 16,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '4.5',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${items.itemsPrice ?? ""}${"EGP".tr}", // تم الإبقاء على العملة الخاصة بك
                                                style: TextStyle(
                                                  fontSize: width * 0.042,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                height: height * 0.05,
                                                width: height * 0.05,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: SvgPicture.asset(
                                                  Imageasset.cart,
                                                  height: 20,
                                                  width: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
