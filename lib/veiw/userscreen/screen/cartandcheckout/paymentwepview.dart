import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
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
  var isPageLoading = true;
  bool _hasCheckedStatus = false; // لمنع التكرار

  @override
  void initState() {
    super.initState();
    paymentUrl = Get.arguments['url'];
    orderId = Get.arguments['order_id'];

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isPageLoading = true),
          onPageFinished: (_) => setState(() => isPageLoading = false),
          onNavigationRequest: (NavigationRequest request) {
            // نتحقق لو الرابط فيه payment-result أو callback
            if ((request.url.contains('payment-result') ||
                    request.url.contains('callback')) &&
                !_hasCheckedStatus) {
              // نمرر الـ orderId اللي جاي من الـ URL أو المتغير الأصلي
              _hasCheckedStatus = true;
              Get.find<Checkoutcontroller>().checkPaymentStatus(orderId);

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      // إضافة ngrok-skip-browser-warning لتخطي شاشة ngrok
      ..loadRequest(
        Uri.parse(paymentUrl),
        headers: {'ngrok-skip-browser-warning': 'true'},
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الدفع'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isPageLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
