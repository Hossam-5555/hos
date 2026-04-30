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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        border: Border.all(
          color: Colors.grey.withAlpha(50),
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
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
        // style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(color: Colors.grey),

          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              color: const Color.fromARGB(255, 103, 105, 105),
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
                  child: VerticalDivider(color: Colors.grey, thickness: 0.5),
                ),
                TextButton(
                  onPressed: onPressedIcon,
                  child: Text(
                    "search".tr,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          filled: true,
          fillColor: Colors.transparent,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
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
