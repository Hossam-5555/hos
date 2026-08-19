import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  late final String paymentUrl;
  var isPageLoading = true;

  @override
  void initState() {
    super.initState();
    // جيب البيانات من الـ arguments
    paymentUrl = Get.arguments['url'];

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => isPageLoading = true),
        onPageFinished: (url) {
          setState(() => isPageLoading = false);

          // لما Paymob تعمل redirect بعد الدفع
          if (url.contains('success') ||
              url.contains('pending') ||
              url.contains('error') ||
              url.contains('txn_response_code')) {
            // Payment status is handled by the checkout flow after the redirect.
          }
        },
      ))
      ..loadRequest(Uri.parse(paymentUrl));
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
          if (isPageLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}