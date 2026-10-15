// المسار المقترح: lib/data/model/couponmodel.dart

enum CouponStatus { active, inactive, expired, usedUp }

class CouponModel {
  final int id;
  final String code;

  /// 'percentage' أو 'fixed'
  final String type;
  final double value;
  final double? minOrderAmount;
  final double? maxDiscount;
  final int? usageLimit;
  final int usedCount;
  final DateTime? expiresAt;
  bool isActive;

  CouponModel({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.minOrderAmount,
    this.maxDiscount,
    this.usageLimit,
    this.usedCount = 0,
    this.expiresAt,
    this.isActive = true,
  });

  // Laravel ساعات بيرجّع الأرقام كـ String (decimal) فبنحوّل بأمان.
  static double? _d(dynamic v) => v == null ? null : double.tryParse('$v');
  static int? _i(dynamic v) => v == null ? null : int.tryParse('$v');
  static bool _b(dynamic v) => v == true || v == 1 || v == '1';

  // TODO: عدّل أسماء الـ keys لو الـ API عندك مختلف
  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: _i(json['id']) ?? 0,
      code: (json['code'] ?? '').toString(),
      type: (json['type'] ?? 'percentage').toString(),
      value: _d(json['value']) ?? 0,
      minOrderAmount: _d(json['min_order_amount']),
      maxDiscount: _d(json['max_discount']),
      usageLimit: _i(json['usage_limit']),
      usedCount: _i(json['used_count']) ?? 0,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.tryParse(json['expires_at'].toString()),
      isActive: _b(json['is_active']),
    );
  }

  bool get isPercentage => type == 'percentage';

  /// الكوبون صالح لحد آخر اليوم المحدد
  bool get isExpired {
    final e = expiresAt;
    if (e == null) return false;
    final endOfDay = DateTime(e.year, e.month, e.day, 23, 59, 59);
    return endOfDay.isBefore(DateTime.now());
  }

  bool get isUsedUp => usageLimit != null && usedCount >= usageLimit!;

  CouponStatus get status {
    if (isExpired) return CouponStatus.expired;
    if (isUsedUp) return CouponStatus.usedUp;
    if (!isActive) return CouponStatus.inactive;
    return CouponStatus.active;
  }
}