import 'package:flutter/material.dart';

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF), // مركز الإضاءة الأبيض المشع
                Color(0xFFF2F4F7), // البلاتينيوم الناعم
                Color(0xFFD0D5DD), // الأطراف الفضية الراقية
              ],
            ),
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_sharp,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
