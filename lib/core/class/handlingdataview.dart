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

  String getEmptyMessage() {
    final Map<String, String> routeMessages = {
      Approute.notificationPage: "No notifications yet".tr,
      Approute.ShoppingCartPage: "Start shopping now".tr,
      Approute.myfavorite: "No items in your favorites".tr,
      Approute.viewmyaddres: "لا يوجد عناوين",
      Approute.Orders: "You have no orders yet".tr,
    };

    return routeMessages[Get.currentRoute] ?? "لا توجد بيانات";
  }

  Widget buildState({
    required BuildContext context,
    required String animation,
    required String? message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animationforstatus(animationPath: animation),

            const SizedBox(height: 30),

            if (message != null)
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (statusrequest == Statusrequest.checkinterner) {
      return buildState(
        context: context,
        animation: Imageasset.loading,
        message: "Check your internet connection",
      );
    }

    if (statusrequest == Statusrequest.loading) {
      return buildState(
        context: context,
        animation: Imageasset.loading,
        message: null,
      );
    }

    if (statusrequest == Statusrequest.failure ||
        statusrequest == Statusrequest.nodata) {
      return buildState(
        context: context,
        animation: Imageasset.nodata,
        message: getEmptyMessage(),
      );
    }

    if (statusrequest == Statusrequest.serverfailure) {
      return buildState(
        context: context,
        animation: Imageasset.nodata,
        message: "Server error, try again later",
      );
    }

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
