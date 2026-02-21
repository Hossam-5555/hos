import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/animation.dart';
// استورد ويدجت الانيميشن الخاصة بك

class Handlingdataview extends StatelessWidget {
  const Handlingdataview({
    super.key,
    required this.statusrequest,
    required this.widget,
  });

  final Statusrequest statusrequest;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    // 1. في حالة الخطأ أو الفشل، نعرض رسالة الخطأ فقط ولا نبني الصفحة الأصلية
    // هذا يمنع الـ Crash الناتج عن محاولة قراءة بيانات فارغة
    String getEmptyMessage() {
      final Map<String, String> routeMessages = {
        Approute.notificationPage: "لا توجد إشعارات",
        Approute.ShoppingCartPage: "السلة فارغة",
        Approute.myfavorite: "المفضلة فارغة",
      };
      print(routeMessages[Get.currentRoute]);
      // بيحاول يجيب الرسالة بناءً على الـ route، ولو مش موجودة بيرجع الرسالة الافتراضية
      return routeMessages[Get.currentRoute] ?? "لا توجد بيانات";
    }

    if (statusrequest == Statusrequest.checkinterner) {
      return Center(
        child: Animationforstatus(animationPath: Imageasset.loading),
      );
    } else if (statusrequest == Statusrequest.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animationforstatus(animationPath: Imageasset.nodata),
            const SizedBox(height: 20),
            Text(
              getEmptyMessage(),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (statusrequest == Statusrequest.serverfailure) {
      // لا توجد بيانات
      return Center(
        child: Animationforstatus(animationPath: Imageasset.nodata),
      );
    }

    // 2. في حالة التحميل (Loading) أو النجاح (Success)
    // نعرض الصفحة الأصلية (التي تحتوي على Skeletonizer)
    return widget;
  }
}

class Handlingdatrequest extends StatelessWidget {
  const Handlingdatrequest({
    super.key,
    required this.statusrequest,
    required this.widget,
    this.onRetry,
  });

  final Statusrequest statusrequest;
  final Widget widget;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Widget buildOverlay(String path, String message) {
      return Container(
        width: width,
        height: height,
        color: Colors.black.withAlpha(50), // خلفية شفافة
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Animationforstatus(animationPath: path),
            const SizedBox(height: 20),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text("إعادة المحاولة"),
                ),
              ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        widget, // الصفحة الأصلية دايمًا ظاهرة
        if (statusrequest == Statusrequest.checkinterner)
          buildOverlay(Imageasset.loading, "جاري التحقق من وجود انترنت ..."),
        if (statusrequest == Statusrequest.loading)
          buildOverlay(Imageasset.animation2, "جاري التحميل ..."),
        if (statusrequest == Statusrequest.failure)
          buildOverlay(Imageasset.animation3, "حدث خطأ في الخادم"),
        if (statusrequest == Statusrequest.serverfailure)
          buildOverlay(Imageasset.animation3, "فشل الاتصال بالخادم"),
      ],
    );
  }
}
