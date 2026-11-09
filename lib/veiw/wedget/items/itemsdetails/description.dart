import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SmartDescriptionView extends StatelessWidget {
  final String rawText; // النص القادم من قاعدة البيانات
  bool isDark;
  SmartDescriptionView({Key? key, required this.rawText, required this.isDark})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 1. تقسيم النص إلى أسطر وتصفية الأسطر الفارغة تماماً
    List<String> lines = rawText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        String trimmedLine = line.trim();

        // 2. التحقق إذا كان السطر يبدأ برقم (قائمة رقمية)
        bool isNumbered = RegExp(r'^\d+').hasMatch(trimmedLine);

        return AnimatedContainer(curve: Curves.bounceOut,
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark ? const Color(0xFF1E1E1E) : Color(0xFFE0E3E8),
          ),
          margin: EdgeInsets.all(5),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // إذا لم يكن رقماً، أضف نقطة جمالية
                if (!isNumbered)
                  Container(
                    margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent, // لون النقطة
                      shape: BoxShape.circle,
                    ),
                  ),

                // محتوى النص
                Expanded(
                  child: Text(
                    trimmedLine,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      // جعل العناوين القصيرة Bold تلقائياً
                      fontWeight: trimmedLine.length < 30 && !isNumbered
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
