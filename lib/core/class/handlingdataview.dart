import 'package:flutter/material.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/animation.dart';

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
    Widget buildAnimation(String path) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 100,),
            Center(child: Animationforstatus(animationPath: path)),
          ],
        ),
      );
    }

    switch (statusrequest) {
      case Statusrequest.checkinterner:
        return buildAnimation(Imageasset.loading);
      case Statusrequest.failure:
        return buildAnimation(Imageasset.nodata);
      case Statusrequest.serverfailure:
        return buildAnimation(Imageasset.loading);
      default:
        return widget;
    }
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
  final VoidCallback? onRetry; // عشان لو عايز تضيف زرار Retry

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    Widget buildAnimation(String path, String message) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: height * 0.75,
              alignment: Alignment.center,
              child: Animationforstatus(animationPath: path),
            ),
            Container(
              width: width,
              alignment: Alignment.center,
              child: Text(
                "$message",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(height: 200),
          ],
        ),
      );
    }

    switch (statusrequest) {
      case Statusrequest.checkinterner:
        return buildAnimation(
          Imageasset.loading,
          "جاري  التحقق من وجود انترنت ...",
        );
      case Statusrequest.loading:
        return buildAnimation(Imageasset.animation2, "جاري التحميل ...");
      case Statusrequest.failure:
        return buildAnimation(Imageasset.animation3, "حدث خطأ في الخادم");
      default:
        return widget;
    }
  }
}
