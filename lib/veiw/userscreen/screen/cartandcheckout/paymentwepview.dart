import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/paymentcontroller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  late final String paymentUrl;
  late final int orderId;
  final PaymentController paymentController = Get.put(PaymentController());

  var isPageLoading = true;
  bool isCheckingStatus = false; // 👈 متغيّر للتحكم بشاشة التأكيد النهائية
  bool _hasCheckedStatus = false;

  @override
  void initState() {
    super.initState();
    paymentUrl = Get.arguments['url'];
    orderId = Get.arguments['order_id'];

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        "Flutter_Mobile_App",
      ) // 👈 يمنع سيرفر ngrok من عرض صفحة التوقف
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => isPageLoading = true);
            _handleUrlRedirect(url); // 👈 افحص الرابط عند بداية تحميله فوراً
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => isPageLoading = false);
            _handleUrlRedirect(url);
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              _handleUrlRedirect(change.url!);
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(paymentUrl),
        headers: {
          'ngrok-skip-browser-warning':
              '69420', // 👈 إرسال أي قيمة لتجاوز التحذير
        },
      );
  }

  void _handleUrlRedirect(String url) {
    // فحص الرابط الظاهر في الـ Log لديك
    bool isCallbackUrl =
        url.contains('/api/payment/callback') ||
        url.contains('merchant_order_id=') ||
        url.contains('payment-result');

    if (isCallbackUrl && !_hasCheckedStatus) {
      _hasCheckedStatus = true;

      // 1️⃣ إظهار واجهة التحميل الاحتجازية فوراً
      if (mounted) {
        setState(() {
          isCheckingStatus = true;
        });
      }
      paymentController.checkPaymentStatus(orderId);
      // 2️⃣ بدء الاستعلام المباشر عبر ה-Controller
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 👈 استخدام PopScope لمنع رجوع المستخدم بالسحب أو الأزرار أثناء التحقق
    return PopScope(
      canPop: !isCheckingStatus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إتمام الدفع الإلكتروني',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          actions: [
            // إخفاء زر الإلغاء تماماً أثناء مرحلة التحقق من الدفع
            if (!isCheckingStatus)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent),
                tooltip: 'إلغاء',
                onPressed: () => _showCancelDialog(),
              ),
          ],
        ),
        body: Stack(
          children: [
            // بوابة الدفع
            WebViewWidget(controller: _controller),

            // 1️⃣ تحميل الصفحات العادية داخل بوابة Paymob
            if (isPageLoading && !isCheckingStatus)
              Container(
                color: Colors.white.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: theme.primaryColor),
                      const SizedBox(height: 16),
                      const Text(
                        'جاري تحميل بوابة الدفع الآمنة...',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

            // 2️⃣ شاشة الاحتجاز الحقيقية: تظهر أثناء الـ Polling وتغطي الشاشة بالكامل برمز غير قابل للتفاعل
            if (isCheckingStatus)
              Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: theme.primaryColor),
                      const SizedBox(height: 20),
                      const Text(
                        'جاري تأكيد عملية الدفع مع البنك...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'يرجى عدم إغلاق التطبيق أو العودة للخلف',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog() {
    Get.defaultDialog(
      title: 'تأكيد الإلغاء',
      middleText: 'هل أنت متأكد من رغبتك في إلغاء عملية الدفع؟',
      textConfirm: 'نعم، إلغاء',
      textCancel: 'تراجع',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.back(); // إغلاق الـ Dialog
        Get.back(); // إغلاق الـ WebView
      },
    );
  }
}
