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
  var isPageLoading = true;

  @override
  void initState() {
    super.initState();
    paymentUrl = Get.arguments['url'];
    final int orderId = Get.arguments['order_id'];

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isPageLoading = true),
          onPageFinished: (url) {
            setState(() => isPageLoading = false);

            // لو الـ URL مش بتاع Paymob → يبقى اتعمل redirect
            if (!url.contains('accept.paymob.com') &&
                !url.contains('mastercard.com') &&
                url != paymentUrl) {
              Get.find<Checkoutcontroller>().checkPaymentStatus(orderId);
            }
          },
        ),
      )
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
          if (isPageLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
