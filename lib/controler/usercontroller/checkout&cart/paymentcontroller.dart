import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/checkoutdata.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/PaymentResultPage.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/paymentwepview.dart';
// قم باستيراد المسارات الخاصة بك بشكل صحيح

class PaymentController extends GetxController {
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  // ==========================================
  // 1. التحقق من حالة الدفع (Polling)
  // ==========================================
  Future<void> checkPaymentStatus(int orderId) async {
    try {
      Map<String, dynamic>? paymentData;
      bool isPaid = false;
  await Future.delayed(const Duration(seconds: 2));
      var result = await checkoutdata.getPaymentStatus(orderId);

      result.fold(
        (failure) => print("⚠️ API Failure in checkPaymentStatus: $failure"),
        (response) {
          print("✅ API Response in checkPaymentStatus: $response");
          if (response['status'] == true && response['data'] != null) {
            paymentData = response['data'];
            String status = (paymentData?['payment_status'] ?? '')
                .toString()
                .toLowerCase();

            if (status == 'paid') {
              isPaid = true;
            }
          }
        },
      );

      Get.off(
        () => PaymentResultPage(
          isSuccess: isPaid,
          orderId: orderId,
          orderNumber: paymentData?['order_number'] ?? '#$orderId',
          amount: paymentData?['amount']?.toString() ?? '',
          transactionId: paymentData?['transaction_id'] ?? 'N/A',
          paymentMethod: paymentData?['payment_method'] ?? 'Visa / Mastercard',
          failureReason: isPaid
              ? ''
              : 'لم يتم تأكيد الدفع بعد، يرجى مراجعة حالة الطلب.',
          onRetry: () => retryPayment(orderId),
        ),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("❌ Error in checkPaymentStatus: $e");
    }
  }

  // ==========================================
  // 2. إعادة محاولة الدفع للأوردر الحالي
  // ==========================================
  Future<void> retryPayment(int orderId) async {
    statusrequest = Statusrequest.loading;
    update();

    try {
      var paymentResponse = await checkoutdata.payment(orderId);

      if (paymentResponse['status'] == true &&
          paymentResponse['data'] != null) {
        String paymentUrl = paymentResponse['data']['payment_url'];

        // التوجيه للـ WebView مع تمرير رابط الدفع الجديد ورقم الأوردر
        Get.to(
          () => const PaymentWebViewScreen(),
          arguments: {'url': paymentUrl, 'order_id': orderId},
        );
      } else {
        showSnackBar(
          Get.context!,
          paymentResponse['message'] ?? "فشل في إعادة إنشاء رابط الدفع",
          const Icon(Icons.error, color: Colors.red),
        );
      }
    } catch (e) {
      print("❌ Error in retryPayment: $e");
      showSnackBar(
        Get.context!,
        "حدث خطأ غير متوقع",
        const Icon(Icons.error, color: Colors.red),
      );
    } finally {
      statusrequest = Statusrequest.none;
      update();
    }
  }

  // ==========================================
  // 3. إلغاء الأوردر
  // ==========================================
  Future<void> cancelOrder(int orderId, BuildContext context) async {
    try {
      statusrequest = Statusrequest.loading;
      update();

      await checkoutdata.cancelOrder(orderId);
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      showSnackBar(
        Get.context!,
        "حدث خطأ في الإلغاء",
        const Icon(Icons.error, color: Colors.red),
      );
    } finally {
      statusrequest = Statusrequest.none;
      update();
    }
  }
}
