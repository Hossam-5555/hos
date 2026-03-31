import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/veiw/wedget/Homepage/productcardHome.dart';

class CurvedItemsView extends StatelessWidget {
  const CurvedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      builder: (controller) {
        // 1. فحص أمان للقائمة فقط: إذا كانت القائمة فارغة، نعرض مؤشر تحميل
        if (controller.items.isEmpty) {
          return const SizedBox(
            height: 290,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. تعيين قيمة افتراضية للـ PageController إذا لم يتم تهيئته في الكنترولر بعد
        // استخدمنا (??) بحيث إذا كان null يأخذ النسخة الافتراضية
        final PageController pageController = controller.pageController ?? 
            PageController(initialPage: 0, viewportFraction: 0.5);

        return SizedBox(
          height: 290,
          child: PageView.builder(
            controller: pageController,
            itemCount: controller.items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
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
                    double currentPage = pageController.page ?? pageController.initialPage.toDouble();
                    
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
                          child: ItemsCardhome(index: index),
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