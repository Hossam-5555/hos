import 'package:flutter/material.dart';

/// مصدر واحد لحالات الأوردر: اللون والأيقونة والاسم (عربي / إنجليزي).
/// عدّل أي لون هنا وهيتغير في كل التطبيق.
enum OrderStatus {
  pending(
    key: 'pending',
    color: Colors.orange,
    icon: Icons.receipt_long,
    en: 'Pending',
    ar: 'قيد الانتظار',
  ),
  processing(
    key: 'processing',
    color: Colors.blue,
    icon: Icons.inventory_2_outlined,
    en: 'Processing',
    ar: 'قيد التجهيز',
  ),
  shipped(
    key: 'shipped',
    color: Color(0xFF9415AD),
    icon: Icons.local_shipping_outlined,
    en: 'Shipped',
    ar: 'في الطريق',
  ),
  delivered(
    key: 'delivered',
    color: Color(0xFF21C90A),
    icon: Icons.check_circle_outline,
    en: 'Delivered',
    ar: 'تم التسليم',
  ),
  cancelled(
    key: 'cancelled',
    color: Colors.red,
    icon: Icons.cancel_outlined,
    en: 'Cancelled',
    ar: 'ملغي',
  ),
  unknown(
    key: 'unknown',
    color: Color(0xC8E2E2E2),
    icon: Icons.help_outline,
    en: 'Unknown',
    ar: 'غير معروف',
  );

  const OrderStatus({
    required this.key,
    required this.color,
    required this.icon,
    required this.en,
    required this.ar,
  });

  final String key;
  final Color color;
  final IconData icon;
  final String en;
  final String ar;

  String label({required bool isArabic}) => isArabic ? ar : en;

  /// يحول النص القادم من الباك إند لحالة. أي قيمة غريبة ترجع unknown.
  static OrderStatus from(String? status) {
    final s = status?.toLowerCase().trim();
    return OrderStatus.values.firstWhere(
      (e) => e.key == s,
      orElse: () => OrderStatus.unknown,
    );
  }

  /// الخطوات اللي بتظهر في الـ timeline (بدون cancelled و unknown).
  static const List<OrderStatus> timeline = [
    pending,
    processing,
    shipped,
    delivered,
  ];
}