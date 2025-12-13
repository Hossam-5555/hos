import 'package:flutter/material.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    Widget buildOverlay(String path) {
      return Container(
        alignment: Alignment.center,
        child: Animationforstatus(animationPath: path),
      );
    }

    return Stack(
      children: [
        Skeletonizer(enableSwitchAnimation: true,
          ignoreContainers: false,
          containersColor: Colors.grey,
          enabled: statusrequest == Statusrequest.loading,
          child: widget,
        ), // 👈 الصفحة الأصلية دايمًا بتتعرض
        // if (statusrequest == Statusrequest.loading)
        //   buildOverlay(Imageasset.loading), // تحميل فوق الصفحة
        if (statusrequest == Statusrequest.failure)
          buildOverlay(Imageasset.nodata), // خطأ أو فشل
        if (statusrequest == Statusrequest.serverfailure)
          buildOverlay(Imageasset.loading), // فشل السيرفر
        if (statusrequest == Statusrequest.checkinterner)
          buildOverlay(Imageasset.loading), // تحقق الإنترنت
      ],
    );
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
        color: Colors.black.withOpacity(0.5), // خلفية شفافة
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
