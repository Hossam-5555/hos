// المسار المقترح: lib/data/datasource/admindata/coupondata.dart
import 'package:hos/core/class/crud.dart';

class AdminCouponData {
  final Crud crud;
  AdminCouponData(this.crud);

  // TODO: ضع رابط الـ endpoint الصحيح من ملف الـ links عندك
  static const String _addUrl = "YOUR_BASE_URL/admin/coupons/add";

  /// كل القيم Strings عشان الـ http post body بيقبل Strings بس.
  Future addCoupon(Map<String, String> data) async {
    // TODO: لو دالة الـ post عندك اسمها مختلف أو بتاخد بارامترات تانية عدّلها
    var response = await crud.postrequset(_addUrl, data);
    return response.fold((l) => l, (r) => r);
  }
}