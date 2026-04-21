import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class BuildCategoryItems extends StatelessWidget {
  final categoriesmodel2 catmodel;
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
    // تعريف الألوان كمتغيرات لسهولة التعديل لاحقاً
    const primaryDark = Color(0xff0F1729);
    const secondaryDark = Color(0xff1F2937);

    return GetBuilder<ItemsControler>(
      builder: (controller) {
        final bool isSelected = controller.selecteditem == i;

        return Padding(
          padding: const EdgeInsets.only(
            right: 10,
            bottom: 5,
            top: 5,
          ), // إضافة مساحة بسيطة للظل
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
                color: isSelected
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.1),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => controller.changcat(i, catmodel.id.toString()),
                splashColor: isSelected ? Colors.white10 : Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIconSection(isSelected, urlIcon, primaryDark),
                      const SizedBox(width: 10),
                      _buildTextSection(isSelected, name),
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
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: isSelected
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipOval(
        child: Image.network(
          url,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, size: 24),
        ),
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
