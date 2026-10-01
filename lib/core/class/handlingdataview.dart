import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// كائن منظم يمثل حالة الصفحة الفارغة
class EmptyStateModel {
  final String title;
  final String subtitle;
  final String imagePath;

  const EmptyStateModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

/// طريقة عرض حالة الطلب
enum HandlingMode {
  /// يستبدل الصفحة كلها
  fullScreen,

  /// اسكيلتون فوق نفس شكل المحتوى
  skeleton,

  /// يظهر فوق المحتوى بستاك (Overlay)
  overlay,
}

/// نمط تصميم الصفحة الفارغة (2 Styles)
enum EmptyStateStyle {
  /// ستايل كلاسيكي بسيط ممتد في المنتصف
  style1,

  /// ستايل عصري محاط بكارت زجاجي وخلفية دائرية للأيقونة
  style2,
}

/// نوع الميديا المستخدمة في العرض
enum HandlingMediaType {
  /// ويدجت الأنيميشن (Animationlottie)
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
    this.emptyStyle = EmptyStateStyle.style1,
    this.loadingWidget,
    this.onRetry,
    this.onTapError,
    this.message,
    this.subMessage,
    this.imagePath,
    this.showRetryButton = true,
  });

  /// حالة الطلب الحالية
  final Statusrequest statusrequest;

  /// المحتوى الأساسي
  final Widget widget;

  /// طريقة العرض: fullScreen / skeleton / overlay
  final HandlingMode mode;

  /// نوع الميديا: انيميشن أو صورة svg أو صورة png
  final HandlingMediaType mediaType;

  /// اختيار ستايل الصفحة الفارغة: style1 أو style2
  final EmptyStateStyle emptyStyle;

  /// ويدجت تحميل مخصص
  final Widget? loadingWidget;

  /// دالة إعادة المحاولة
  final VoidCallback? onRetry;

  /// دالة تُنفذ عند الضغط على شاشة الخطأ في وضع overlay
  final VoidCallback? onTapError;

  /// رسالة عنوان مخصصة
  final String? message;

  /// رسالة فرعية مخصصة
  final String? subMessage;

  /// مسار صورة/أنيميشن مخصص
  final String? imagePath;

  /// إظهار/إخفاء زرار إعادة المحاولة
  final bool showRetryButton;

  // ---------------------------------------------------------------------
  // خريطة البيانات المنظمة لجميع الراوتات بالتطبيقات الكبرى
  // ---------------------------------------------------------------------
  Map<String, EmptyStateModel> get _routeMessages => {
    Approute.notificationPage: EmptyStateModel(
      title: "No notifications yet".tr,
      subtitle: "We'll notify you when something important arrives.".tr,
      imagePath: Imageasset.emptyNotification,
    ),
    Approute.ShoppingCartPage: EmptyStateModel(
      title: "Your shopping cart is empty".tr,
      subtitle: "Explore our items and add them to your cart now!".tr,
      imagePath: "assets/images/empty_cart.svg",
    ),
    Approute.myfavorite: EmptyStateModel(
      title: "No favorites saved yet".tr,
      subtitle:
          "Tap the heart icon on any product to save it here for later.".tr,
      imagePath: Imageasset.emptyfavorite,
    ),
    Approute.viewmyaddres: EmptyStateModel(
      title: "No addresses found".tr,
      subtitle: "Add a shipping address to ensure fast and smooth delivery.".tr,
      imagePath: Imageasset.emptyAddress,
    ),
    Approute.Orders: EmptyStateModel(
      title: "You haven't placed any orders".tr,
      subtitle:
          "Once you place an order, you can track its status right here.".tr,
      imagePath: Imageasset.emptyNotification,
    ),
    Approute.Items: EmptyStateModel(
      title: "No products in this category".tr,
      subtitle: "Check back later or try exploring another category.".tr,
      imagePath: Imageasset.nodata,
    ),
    AdminApproate.viewitemscreen: EmptyStateModel(
      title: "Category is empty".tr,
      subtitle:
          "Add new items to this category to make them available to users.".tr,
      imagePath: Imageasset.emptycart,
    ),
  };

  EmptyStateModel _defaultForRoute() {
    final data = _routeMessages[Get.currentRoute];
    return data ??
        EmptyStateModel(
          title: "No data available".tr,
          subtitle: "We couldn't find any information to display right now.".tr,
          imagePath: Imageasset.emptycart,
        );
  }

  // ---------------------------------------------------------------------
  // اختيار الرسالة الرئيسية حسب الحالة
  // ---------------------------------------------------------------------
  String _getTitle() {
    if (message != null) return message!;
    switch (statusrequest) {
      case Statusrequest.checkinterner:
        return "No Internet Connection".tr;
      case Statusrequest.loading:
        return "Loading...".tr;
      case Statusrequest.serverfailure:
        return "Server Error".tr;
      case Statusrequest.failure:
      case Statusrequest.nodata:
        return _defaultForRoute().title;
      default:
        return "";
    }
  }

  // ---------------------------------------------------------------------
  // اختيار الرسالة الفرعية حسب الحالة
  // ---------------------------------------------------------------------
  String _getSubtitle() {
    if (subMessage != null) return subMessage!;
    switch (statusrequest) {
      case Statusrequest.checkinterner:
        return "Please check your network settings and try again.".tr;
      case Statusrequest.serverfailure:
        return "Something went wrong on our end. Please try again later.".tr;
      case Statusrequest.failure:
      case Statusrequest.nodata:
        return _defaultForRoute().subtitle;
      default:
        return "";
    }
  }

  // ---------------------------------------------------------------------
  // اختيار مسار الميديا
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
        return _defaultForRoute().imagePath;
      default:
        return Imageasset.nodata;
    }
  }

  // ---------------------------------------------------------------------
  // بناء الميديا (انيميشن / svg / png)
  // ---------------------------------------------------------------------
  Widget _buildMedia({double? width, double? height, bool isTablet = false}) {
    final path = _getImagePath();
    final double defaultSize = isTablet ? 230 : 170;
    final w = width ?? defaultSize;
    final h = height ?? defaultSize;

    if (statusrequest == Statusrequest.loading) {
      return Animationlottie(animationPath: Imageasset.loading, h: h, w: w);
    } else {
      switch (mediaType) {
        case HandlingMediaType.animation:
          return Animationlottie(animationPath: path, h: h, w: w);
        case HandlingMediaType.svgImage:
          return SvgPicture(
            SvgAssetLoader(path),
            width: w,
            height: h,
            fit: BoxFit.contain,
          );
        case HandlingMediaType.pngImage:
          return Image.asset(path, width: w, height: h, fit: BoxFit.contain);
      }
    }
  }

  // ---------------------------------------------------------------------
  // Style 1: كلاسيكي متمحور ونظيف
  // ---------------------------------------------------------------------
  Widget _buildStyle1(BuildContext context) {
    final title = _getTitle();
    final subtitle = _getSubtitle();
    final canRetry =
        (statusrequest == Statusrequest.checkinterner ||
            statusrequest == Statusrequest.serverfailure) &&
        onRetry != null &&
        showRetryButton;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMedia(isTablet: MediaQuery.of(context).size.width >= 600),
          const SizedBox(height: 24),
          if (title.isNotEmpty)
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF16181D),
              ),
            ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
          if (canRetry)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Checkbutton(
                width: context.width * 0.45,
                onTap: onRetry!,
                buttonName: "Try again".tr,
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Style 2: عصري بتصميم الكارت والخلفيات الدائرية
  // ---------------------------------------------------------------------
  Widget _buildStyle2(BuildContext context) {
    final title = _getTitle();
    final subtitle = _getSubtitle();
    final canRetry = onRetry != null && showRetryButton;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2026) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white10 : Color(0xFFE0E3E8),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    offset: const Offset(0, 4),
                  ),
                ],
                color: isDark ? Colors.white.withAlpha(13) : Color(0xFFE0E3E8),
              ),
              child: _buildMedia(width: 120, height: 120),
            ),
            const SizedBox(height: 20),
            if (title.isNotEmpty)
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
            if (canRetry)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Checkbutton(
                width: context.width * 0.4,
                onTap: onRetry!,
                buttonName: "Try again".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // التبديل بين الستايلين في الوضع الكامل
  // ---------------------------------------------------------------------
  Widget _buildFullState(BuildContext context) {
    return Center(
      child: emptyStyle == EmptyStateStyle.style1
          ? _buildStyle1(context)
          : _buildStyle2(context),
    );
  }

  // ---------------------------------------------------------------------
  // شكل الـ Overlay
  // ---------------------------------------------------------------------
  Widget _buildOverlay(BuildContext context, {required bool isInteractive}) {
    final title = _getTitle();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isInteractive ? Colors.transparent : Colors.black.withAlpha(76),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: _buildMedia(width: 120, height: 120),
          ),
          const SizedBox(height: 20),
          if (title.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 15),
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

    // ---------------- وضع Overlay ----------------
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
