import 'package:flutter/material.dart';
import 'package:get/get.dart';

// تحديد أنواع طرق الدفع المتاحة
enum PaymentMethod { creditCard, mobileWallet, cod,none }

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var paymentUrl = ''.obs;
  final formKey = GlobalKey<FormState>();

  Future<void> initiatePayment(int orderId) async {
    isLoading.value = true;
    try {
      // final response = await ApiService.post('/payment/initiate/$orderId');
      // paymentUrl.value = response['payment_url'];
      // Get.to(() => PaymentWebViewScreen(url: paymentUrl.value, orderId: orderId));
    } catch (e) {
      Get.snackbar('خطأ', 'فشل بدء عملية الدفع');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkPaymentStatus(int orderId) async {
    // final response = await ApiService.get('/payment/status/$orderId');
    // if (response['status'] == 'paid') {
    //   Get.offAll(() => PaymentSuccessScreen());
    // } else if (response['status'] == 'failed') {
    //   Get.offAll(() => PaymentFailedScreen());
    // }
  }
}