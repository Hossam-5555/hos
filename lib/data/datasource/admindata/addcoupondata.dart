// المسار المقترح: lib/data/datasource/admindata/coupondata.dart
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class AdminCouponData {
  final Crud crud;
  AdminCouponData(this.crud);

  // كل القيم Strings عشان الـ http post body بيقبل Strings بس.

  Future addCoupon(Map<String, String> data) async {
    var response = await crud.postrequset(LinkApi.addCoupon, data);
    return response.fold((l) => l, (r) => r);
  }

  Future getCoupons() async {
    var response = await crud.postrequset(LinkApi.viewCoupons, {});
    return response.fold((l) => l, (r) => r);
  }

  Future toggleCoupon(String id, bool active) async {
    var response = await crud.postrequset(LinkApi.toggleCoupon, {
      'id': id,
      'is_active': active ? '1' : '0',
    });
    return response.fold((l) => l, (r) => r);
  }

  Future deleteCoupon(String id) async {
    var response = await crud.postrequset(LinkApi.deleteCoupon, {'id': id});
    return response.fold((l) => l, (r) => r);
  }
}
