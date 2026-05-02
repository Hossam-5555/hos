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
        Approute.notificationPage: "No notifications yet".tr,
        Approute.ShoppingCartPage: "Start shopping now".tr,
        Approute.myfavorite: "No items in your favorites".tr,
        Approute.viewmyaddres: "لا يوجد عناوين",
        Approute.Orders: "You have no orders yet".tr,
      };
      print(routeMessages[Get.currentRoute]);
      // بيحاول يجيب الرسالة بناءً على الـ route، ولو مش موجودة بيرجع الرسالة الافتراضية
      return routeMessages[Get.currentRoute] ?? "لا توجد بيانات";
    }

    // String getEmptyAnimation() {
    //   final Map<String, String> routeanimations = {
    //     Approute.notificationPage: Imageasset.nodata,
    //     Approute.ShoppingCartPage: Imageasset.nodata,
    //     Approute.myfavorite: Imageasset.nodata,
    //     Approute.viewmyaddres: Imageasset.nodata,
    //     Approute.Orders: Imageasset.nodata,
    //   };
    //   print(routeanimations[Get.currentRoute]);
    //   // بيحاول يجيب الرسالة بناءً على الـ route، ولو مش موجودة بيرجع الرسالة الافتراضية
    //   return routeanimations[Get.currentRoute] ?? "لا توجد بيانات";
    // }

    if (statusrequest == Statusrequest.checkinterner) {
      return Center(
        child: Animationforstatus(animationPath: Imageasset.loading),
      );
    } else if (statusrequest == Statusrequest.failure ||
        statusrequest == Statusrequest.nodata) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animationforstatus(animationPath: Imageasset.nodata),
            const SizedBox(height: 50),
            Text(
              getEmptyMessage(),
              style: Theme.of(context).textTheme.bodyMedium,
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
    } else if (statusrequest == Statusrequest.nodata) {
      return Center(child: Animationforstatus(animationPath: Imageasset.nodata));
    }

    // 2. في حالة التحميل (Loading) أو النجاح (Success)
    // نعرض الصفحة الأصلية (التي تحتوي على Skeletonizer)
    return widget;
  }
}

// handlingdatrequest.dart
class Handlingdatrequest extends StatelessWidget {
  const Handlingdatrequest({
    super.key,
    required this.statusrequest,
    required this.widget,
    this.onRetry,
    // ✅ إضافة خاصية جديدة
    this.onTapError,
  });

  final Statusrequest statusrequest;
  final Widget widget;
  final VoidCallback? onRetry;
  // ✅ إضافة دالة لتغيير الحالة
  final VoidCallback? onTapError;

  @override
  Widget build(BuildContext context) {
    bool isError =
        statusrequest == Statusrequest.failure ||
        statusrequest == Statusrequest.serverfailure;

    bool isLoading =
        statusrequest == Statusrequest.loading ||
        statusrequest == Statusrequest.checkinterner;

    return Stack(
      children: [
        // الصفحة الأصلية
        widget,

        // إذا كان هناك تحميل: نمنع اللمس ونغطي الشاشة
        if (isLoading) _buildOverlay(context, isInteractive: false),

        // إذا كان هناك خطأ: نظهر رسالة لكن نسمح باللمس من خلال IgnorePointer
        if (isError)
          IgnorePointer(
            ignoring:
                false, // يجب أن تكون false لكي يستقبل GestureDetector اللمس
            child: GestureDetector(
              // ✅ استدعاء دالة تغيير الحالة عند النقر
              onTap: onTapError,
              child: _buildOverlay(context, isInteractive: true),
            ),
          ),
      ],
    );
  }

  Widget _buildOverlay(BuildContext context, {required bool isInteractive}) {
    final size = MediaQuery.of(context).size;
    String path = _getAnimationPath();
    String message = _getMessage();

    return Container(
      width: size.width,
      height: size.height,
      // في حالة الخطأ، نجعل الخلفية شفافة لكنها لا تزال تغطي الشاشة لاستقبال النقر
      color: isInteractive ? Colors.transparent : Colors.black.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // تأكد من أن الـ Animationforstatus لا تغطي حقل الإدخال
          Animationforstatus(animationPath: path),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          // زر المحاولة
          if (onRetry != null &&
              !isInteractive) // لا نظهر الزر إذا كنا نسمح بالتفاعل للخلف
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

  // الدوال المساعدة (نفسها كما كانت)
  String _getAnimationPath() {
    if (statusrequest == Statusrequest.loading) return Imageasset.animation2;
    if (statusrequest == Statusrequest.checkinterner) return Imageasset.loading;
    return Imageasset.animation3; // للخطأ
  }

  // دالة مساعدة للحصول على الرسالة
  String _getMessage() {
    if (statusrequest == Statusrequest.loading) return "جاري التحميل ...";
    if (statusrequest == Statusrequest.checkinterner)
      return "جاري التحقق من الانترنت ...";
    return "حدث خطأ ما";
  }
}
