import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// طريقة عرض حالة الطلب
enum HandlingMode {
  /// يستبدل الصفحة كلها (زي Handlingdataview القديم)
  fullScreen,

  /// اسكيلتون فوق نفس شكل المحتوى
  skeleton,

  /// يظهر فوق المحتوى بستاك (زي Handlingdatrequest القديم)
  /// - ده اللي بيخليك تحطه فوق أي جزء في الصفحة (فورم، لستة، أي حاجة)
  overlay,
}

/// نوع الميديا المستخدمة في العرض
enum HandlingMediaType {
  /// ويدجت الأنيميشن بتاعتك (Animationforstatus)
  animation,

  /// صورة SVG ثابتة
  svgImage,

  /// صورة PNG/JPG ثابتة
  pngImage,
}

class HandlingDataView extends StatelessWidget {
  const HandlingDataView({
    super.key,
    required this.statusrequest,
    required this.widget,
    this.mode = HandlingMode.fullScreen,
    this.mediaType = HandlingMediaType.animation,
    this.loadingWidget,
    this.onRetry,
    this.onTapError,
    this.message,
    this.imagePath,
    this.showRetryButton = true,
  });

  /// حالة الطلب الحالية
  final Statusrequest statusrequest;

  /// المحتوى الأساسي (الصفحة أو الويدجت اللي هيتحط فوقه/بدل منه الحالة)
  final Widget widget;

  /// طريقة العرض: fullScreen / skeleton / overlay
  final HandlingMode mode;

  /// نوع الميديا: انيميشن أو صورة svg أو صورة png - غيّرها حسب رغبتك
  final HandlingMediaType mediaType;

  /// ويدجت تحميل مخصص (يستخدم فقط في وضع fullScreen)
  final Widget? loadingWidget;

  /// دالة إعادة المحاولة (بتظهر كزرار)
  final VoidCallback? onRetry;

  /// دالة تُنفذ عند الضغط على شاشة الخطأ في وضع overlay
  final VoidCallback? onTapError;

  /// رسالة مخصصة (لو مبعتهاش هتاخد رسالة افتراضية حسب الحالة/الراوت)
  final String? message;

  /// مسار صورة/أنيميشن مخصص (لو مبعتهوش هياخد مسار وهمي افتراضي - استبدله بمسارك الحقيقي)
  final String? imagePath;

  /// إظهار/إخفاء زرار إعادة المحاولة
  final bool showRetryButton;

  // ---------------------------------------------------------------------
  // رسائل وصور "وهمية" افتراضية لكل راوت - استبدل المسارات دي بصورك الحقيقية
  // ---------------------------------------------------------------------
  Map<String, List<String>> get _routeMessages => {
    Approute.notificationPage: [
      "No notifications yet".tr,
      Imageasset.emptyNotification,
    ],
    Approute.ShoppingCartPage: [
      "Start shopping now".tr,
      "assets/images/empty_cart.svg",
    ],
    Approute.myfavorite: [
      "No favorites yet — go find something you'll love!",
      Imageasset.emptystate,
    ],
    Approute.viewmyaddres: ["Add new address".tr, Imageasset.emptystate],
    Approute.Orders: [
      "You have no orders yet".tr,
      "assets/images/empty_orders.svg",
    ],
    Approute.Items: ["No items in this Category yet", Imageasset.emptycart],
    AdminApproate.ViewItemScreen: [
      "No items in this Category yet",
      Imageasset.emptycart,
    ],
  };

  List<String> _defaultForRoute() {
    final data = _routeMessages[Get.currentRoute];
    return data ?? ["No data found".tr, Imageasset.emptycart];
  }

  // ---------------------------------------------------------------------
  // اختيار الرسالة المناسبة حسب الحالة
  // ---------------------------------------------------------------------
  String _getMessage() {
    if (message != null) return message!;
    switch (statusrequest) {
      case Statusrequest.checkinterner:
        return "Check your internet connection".tr;
      case Statusrequest.loading:
        return "Loading...".tr;
      case Statusrequest.serverfailure:
        return "Server error, try again later".tr;
      case Statusrequest.failure:
      case Statusrequest.nodata:
        return _defaultForRoute()[0];
      default:
        return "";
    }
  }

  // ---------------------------------------------------------------------
  // اختيار مسار الصورة/الأنيميشن المناسب حسب الحالة (مسارات وهمية - استبدلها)
  // ---------------------------------------------------------------------
  String _getImagePath() {
    if (imagePath != null) return imagePath!;
    switch (statusrequest) {
      case Statusrequest.checkinterner:
        return Imageasset.offline;
      case Statusrequest.loading:
        return Imageasset.loading;
      case Statusrequest.serverfailure:
        return Imageasset.nodata;
      case Statusrequest.failure:
      case Statusrequest.nodata:
        return _defaultForRoute()[1];
      default:
        return Imageasset.nodata;
    }
  }

  // ---------------------------------------------------------------------
  // بناء الميديا (انيميشن / svg / png) حسب mediaType المختار
  // ---------------------------------------------------------------------
  Widget _buildMedia({double? width, double? height, isTablet}) {
    final path = _getImagePath();
    switch (mediaType) {
      case HandlingMediaType.animation:
        return Animationlottie(
          animationPath: path,
          h: isTablet ? 240 : 190,
          w: isTablet ? 240 : 190,
        );
      case HandlingMediaType.svgImage:
        return SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: BoxFit.contain,
        );
      case HandlingMediaType.pngImage:
        return Image.asset(
          path,
          width: width,
          height: height,
          fit: BoxFit.contain,
        );
    }
  }

  // ---------------------------------------------------------------------
  // شكل الحالة الكامل (يستخدم في وضع fullScreen)
  // ---------------------------------------------------------------------
  Widget _buildFullState(BuildContext context) {
    final msg = _getMessage();
    final canRetry =
        statusrequest != Statusrequest.loading &&
        statusrequest != Statusrequest.checkinterner &&
        onRetry != null;

    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(25),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: _buildMedia(
                    isTablet: MediaQuery.of(context).size.width >= 600,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              if (msg.isNotEmpty)
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF16181D),
                  ),
                ),

              const SizedBox(height: 6),

              Text(
                "Try searching with another name or category.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              if (canRetry)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: onRetry,
                    child: Text("Try again"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // شكل الأوفرلاي (يستخدم في وضع overlay) - يتحط فوق أي حتة في الصفحة
  // ---------------------------------------------------------------------
  Widget _buildOverlay(BuildContext context, {required bool isInteractive}) {
    final msg = _getMessage();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isInteractive ? Colors.transparent : Colors.black.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: _buildMedia(width: 120, height: 120),
          ),
          const SizedBox(height: 20),
          if (msg.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                msg,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          if (onRetry != null && !isInteractive && showRetryButton)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text("Try again".tr),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        statusrequest == Statusrequest.loading ||
        statusrequest == Statusrequest.checkinterner;
    final isError =
        statusrequest == Statusrequest.failure ||
        statusrequest == Statusrequest.serverfailure ||
        statusrequest == Statusrequest.nodata;

    // ---------------- وضع Skeleton ----------------
    if (mode == HandlingMode.skeleton) {
      return Skeletonizer(enabled: isLoading, child: widget);
    }

    // ---------------- وضع FullScreen ----------------
    if (mode == HandlingMode.fullScreen) {
      if (isLoading) {
        if (statusrequest == Statusrequest.loading && loadingWidget != null) {
          return loadingWidget!;
        }
        return _buildFullState(context);
      }
      if (isError) {
        return _buildFullState(context);
      }
      return widget;
    }

    // ---------------- وضع Overlay (يتحط فوق أي حتة في الصفحة) ----------------
    return Stack(
      children: [
        widget,
        if (isLoading)
          Positioned.fill(child: _buildOverlay(context, isInteractive: false)),
        if (isError)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: GestureDetector(
                onTap: onTapError,
                child: _buildOverlay(context, isInteractive: true),
              ),
            ),
          ),
      ],
    );
  }
}
