import 'package:flutter/material.dart';

class SmartDescriptionView extends StatelessWidget {
  final String rawText; // النص القادم من قاعدة البيانات

   SmartDescriptionView({Key? key, required this.rawText,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 1. تقسيم النص إلى أسطر وتصفية الأسطر الفارغة تماماً
    List<String> lines = rawText.split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        String trimmedLine = line.trim();

        // 2. التحقق إذا كان السطر يبدأ برقم (قائمة رقمية)
        bool isNumbered = RegExp(r'^\d+').hasMatch(trimmedLine);

        return Padding(
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
                    color: Colors.black87,
                    // جعل العناوين القصيرة Bold تلقائياً
                    fontWeight: trimmedLine.length < 30 && !isNumbered 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}