import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class BuildCategoryItems extends StatelessWidget {
  final CategoriesModel catmodel;
  final int i;
  final String urlIcon;

  const BuildCategoryItems({
    super.key,
    required this.catmodel,
    required this.i,
    required this.urlIcon,
  });

  @override
  Widget build(BuildContext context) {
    String name = catmodel.name ?? "";

    // 1. معرفة وضع التطبيق الحالي (ليلي أم فاتح)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<ItemsController>(
      builder: (controller) {
        final bool isSelected = controller.selecteditem == i;

        // 2. ألوان البوردر المتدرج (الخارجي)
        final borderGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0], // لمعة في الأطراف وتختفي في المنتصف
          colors: isSelected
              ? (isDarkMode
                    ? [
                        const Color(
                          0xFFEAAFC8,
                        ).withOpacity(0.8), // لمعة بينك/بيضاء (وضع ليلي)
                        Colors.transparent,
                        Colors.white.withOpacity(0.3),
                      ]
                    : [
                        Colors.blue.withOpacity(0.5), // لمعة زرقاء (وضع فاتح)
                        Colors.transparent,
                        Colors.blueAccent.withOpacity(0.2),
                      ])
              : (isDarkMode
                    ? [
                        Colors.white.withOpacity(
                          0.1,
                        ), // بوردر خفيف جداً لغير المحدد
                        Colors.transparent,
                        Colors.white.withOpacity(0.02),
                      ]
                    : [
                        Colors.grey.shade300,
                        Colors.transparent,
                        Colors.grey.shade100,
                      ]),
        );

        // 3. لون الخلفية الداخلية
        final innerColor = isSelected
            ? (isDarkMode ? const Color(0xFF120F11) : Colors.white)
            : (isDarkMode
                  ? Colors.white.withOpacity(0.03)
                  : Colors.grey.shade50);

        // 4. الظل للزرار المحدد فقط
        final boxShadow = isSelected
            ? [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : <BoxShadow>[];

        return Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastLinearToSlowEaseIn,
            // الـ Container الخارجي (البوردر)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: borderGradient,
              boxShadow: boxShadow,
            ),
            // سُمك البوردر هو الـ Padding ده (1.5 بكسل)
            padding: const EdgeInsets.all(1.5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastLinearToSlowEaseIn,
              // الـ Container الداخلي (الخلفية)
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  28.5,
                ), // الراديوس أقل قليلاً من الخارجي
                color: innerColor,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28.5),
                  onTap: () => controller.changcat(i, catmodel.id.toString()),
                  splashColor: isDarkMode ? Colors.white10 : Colors.black12,
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, // كبرت المسافة شوية عشان الفخامة
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTextSection(isSelected, name, isDarkMode),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ... (كود الأيقونة الخاص بك إذا أردت استخدامه)

  // تعديل بسيط على النص ليتناسب مع الوضعين
  Widget _buildTextSection(bool isSelected, String title, bool isDarkMode) {
    // الألوان بناءً على الوضع والاختيار
    final activeColor = isDarkMode ? Colors.white : Colors.blue;
    final inactiveColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: isSelected ? activeColor : inactiveColor,
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        letterSpacing: 0.3,
      ),
      child: Text(title),
    );
  }
}
