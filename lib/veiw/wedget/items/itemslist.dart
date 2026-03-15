import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class BuildCategoryItems extends StatelessWidget {
  final categoriesmodel catmodel;
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
    // تعريف الألوان كمتغيرات لسهولة التعديل لاحقاً
    const primaryDark = Color(0xff0F1729);
    const secondaryDark = Color(0xff1F2937);

    return GetBuilder<ItemsControler>(
      builder: (controller) {
        final bool isSelected = controller.selecteditem == i;

        return Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 8, top: 8), // إضافة مساحة بسيطة للظل
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastLinearToSlowEaseIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [primaryDark, secondaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.grey.withOpacity(0.08),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.1),
              ),
          
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => controller.changcat(i, catmodel.categoriesId!),
                splashColor: isSelected ? Colors.white10 : Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIconSection(isSelected, urlIcon, primaryDark),
                      const SizedBox(width: 10),
                      _buildTextSection(isSelected, catmodel.categoriesName ?? ''),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // فصل الأيقونة في Widget خاص لتسهيل القراءة
  Widget _buildIconSection(bool isSelected, String url, Color activeColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: isSelected 
            ? [] 
            : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: SvgPicture.network(
        url,
        height: 20, // تقليل الحجم قليلاً ليتناسب مع التصميم العصري
        width: 20,
        colorFilter: ColorFilter.mode(
          isSelected ? Colors.white : activeColor,
          BlendMode.srcIn,
        ),
        placeholderBuilder: (_) => const SizedBox(
          width: 20, height: 20, 
          child: CircularProgressIndicator(strokeWidth: 1, color: Colors.grey)
        ),
        errorBuilder: (_, __, ___) => const Icon(Icons.category_outlined, size: 20),
      ),
    );
  }

  // فصل النص في Widget خاص
  Widget _buildTextSection(bool isSelected, String title) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        letterSpacing: 0.3,
      ),
      child: Text(title),
    );
  }
}