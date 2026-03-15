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
    return Card(
      color: const Color(0xffF5F6F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: TextFormField(
        focusNode: focusNode,
        textInputAction: textInputAction,
        controller: mycontroller,
        onChanged: onChanged,
        onFieldSubmitted: (value) {
          if (onPressedIcon != null) {
            onPressedIcon!();
          }
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(color: Colors.grey),

          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(color: const Color.fromARGB(255, 14, 16, 17),
              Imageasset.search,
              height: 20,
              width: 20,
            ),
          ),

          suffixIcon: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 20,
                  child: VerticalDivider(color: Colors.grey, thickness: 1),
                ),
                TextButton(
                  onPressed: onPressedIcon,
                  child: Text(
                    "search".tr,
                    style: TextStyle(
                      color: Color(0xff9B2501),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          filled: true,
          fillColor: Colors.transparent,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
