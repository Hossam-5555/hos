import 'package:flutter/material.dart';
import 'package:get/get.dart';

// تحديد أنواع طرق الدفع المتاحة
enum PaymentMethod { creditCard, mobileWallet, cod,none }

class PaymentController extends GetxController {
  // استخدام .obs لجعل المتغير تفاعلياً (Reactive)
  var selectedMethod = PaymentMethod.creditCard.obs;
  
  // مفتاح الفورم للتحقق من صحة البيانات
  final formKey = GlobalKey<FormState>();

  // دالة لتغيير طريقة الدفع
  void changePaymentMethod(PaymentMethod method) {
    selectedMethod.value = method;
  }

  // دالة إتمام الدفع
  void addpayment() {
    // التحقق: إما الدفع عند الاستلام أو أن حقول الفورم صحيحة
    if (selectedMethod.value == PaymentMethod.cod || (formKey.currentState?.validate() ?? false)) {
      // استبدلنا ScaffoldMessenger بـ Get.snackbar لسهولة الاستخدام
      Get.snackbar(
        'جاري المعالجة',
        'يتم الآن معالجة عملية الدفع الخاصة بك...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      
      // هنا يمكنك كتابة كود إرسال البيانات للـ API
    }
  }
}