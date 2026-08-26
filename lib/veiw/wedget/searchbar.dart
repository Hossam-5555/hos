import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';

// ignore: must_be_immutable
class Searchbar extends StatelessWidget {
  final void Function()? onPressedIcon;
  final Function(String)? onChanged;
  final TextEditingController mycontroller;
  final String title;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const Searchbar({
    super.key,
    this.onPressedIcon,
    required this.title,
    this.onChanged,
    required this.mycontroller,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      focusNode: focusNode,
      textInputAction: textInputAction,
      controller: mycontroller,
      onChanged: onChanged,
    
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.grey),
    
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            Imageasset.search,
            height: 20,
            width: 20,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
    
        suffixIcon: SizedBox(
          width: 100,
          child: TextButton(
            onPressed: onPressedIcon,
            child: Text(
              "search".tr,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
    
        // خلفية الحقل
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
    
        // الشكل الطبيعي
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:BorderSide.none,
        ),
    
        // عند الضغط عليه
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:BorderSide.none,
        ),
      ),
    );
  }
}
