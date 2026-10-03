import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceText extends StatelessWidget {
  const PriceText(
    this.price, {
    super.key,
    this.fontSize = 14,
    this.color =  Colors.greenAccent,
    this.isOld = false, // السعر القديم (رمادي ومشطوب)
  });

  /// يقبل int / double / String
  final dynamic price;
  final double fontSize;
  final Color color;
  final bool isOld;

  String get _formatted {
    final n = num.tryParse(price.toString());
    if (n == null) return price.toString();
    return n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final c = isOld ? Colors.grey : color;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: _formatted,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isOld ? FontWeight.w500 : FontWeight.w800,
            ),
          ),
          TextSpan(
            text: ' ${"EGP".tr}',
            style: TextStyle(
              fontSize: fontSize * 0.78,
              fontWeight: FontWeight.w600,
              color: c.withAlpha(200),
            ),
          ),
        ],
      ),
      style: TextStyle(
        color: c,
        decoration: isOld ? TextDecoration.lineThrough : null,
      ),
    );
  }
}