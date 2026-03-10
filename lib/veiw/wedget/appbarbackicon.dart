import 'package:flutter/material.dart';

class Appbarbackicon extends StatelessWidget implements PreferredSizeWidget {
  const Appbarbackicon({
    super.key,
    required this.title,
    required this.herotag,
    this.selected = false, // خلي الديفولت false بدل null
    this.onPressed,
    this.iconButton,
  });

  final String title;
  final String herotag;
  final bool? selected;
  final void Function()? onPressed;
  final Widget? iconButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent, // اختياري لشكل أنظف
      actions: [if (selected == true && iconButton != null) iconButton!],
      title: Text(title, style: const TextStyle(color: Colors.black)),
      centerTitle: true,
      leadingWidth: 70, // زيادة العرض قليلاً عشان الدايرة متتحشرش
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Center(
          child: Hero(
            // تأكد أن الـ tag فريد لكل صفحة
            tag: herotag,
            child: Container(
              width: 45, // حجم متناسق أكتر مع الـ AppBar
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                // ضروري جداً داخل Hero عشان الـ Splash يظهر صح
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    // ✅ حماية: اقفل أي رسالة مفتوحة قبل ما ترجع
                    Navigator.of(context).pop();
                    // ✅ رجوع للصفحة السابقة
                  },
                  icon: Icon(
                    selected == true ? Icons.close : Icons.arrow_back_ios_sharp,
                    color: Colors.black,
                  ),
                  iconSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ضروري عشان الـ Scaffold يقبلها كـ AppBar مباشرة
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
