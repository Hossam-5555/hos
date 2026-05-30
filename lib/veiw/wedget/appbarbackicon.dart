import 'package:flutter/material.dart';

class Appbarbackicon extends StatelessWidget implements PreferredSizeWidget {
  const Appbarbackicon({
    super.key,
    required this.title,
    required this.herotag,
    this.selected = false, // تم تعديل النوع ليكون متوافق تماماً مع bool
    this.onPressed,
    this.iconButton,
  });

  final String title;
  final String herotag;
  final bool selected; // تغييرها من bool? إلى bool
  final void Function()? onPressed;
  final Widget? iconButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [if (selected == true && iconButton != null) iconButton!],
      title: Text(title),
      centerTitle: true,
      leadingWidth: 70, 
      leading: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
        child: Center(
          child: Hero(
            tag: herotag,
            child: Container(
              width: 45, 
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
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    if (selected == true) {
                      // 💚 التعديل السحري: استدعاء الدالة بشكل صحيح بالأقواس ()
                      if (onPressed != null) {
                        onPressed!(); 
                      }
                    } else {
                      Navigator.of(context).pop();
                    }
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}