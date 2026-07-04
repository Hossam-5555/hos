import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/items/filteritems.dart';

class FilterButton extends StatelessWidget {
  final dynamic controller;

  const FilterButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: MaterialButton(padding: EdgeInsets.all(5),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            // إزالة اللون الثابت ليتماشى مع التعديلات التي أجريناها في الـ Sheet
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => const AdvancedFilterSheet(),
          );
        },
        child: SvgPicture.asset(Imageasset.category, height: 25, width: 25),
      ),
    );
  }
}

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
