import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Textfealdauth extends StatelessWidget {
  Textfealdauth({
    super.key,
    this.obscureText,
    this.onTapIcon,
    required this.suffixIcon,
    required this.hint,
    required this.textEditingController,
    required this.valid,
  });

  TextEditingController textEditingController;
  String hint;
  late IconData suffixIcon;
  String? Function(String?)? valid;
  void Function()? onTapIcon;
  bool? obscureText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: TextFormField(
        style: TextStyle(
          // color: const Color.fromARGB(255, 10, 10, 10),
          fontSize: width * 0.045, // حجم الخط متناسب مع العرض
          fontWeight: FontWeight.w500,
        ),
        obscureText: obscureText ?? false,
        validator: valid,
        controller: textEditingController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withAlpha(20)
              : Colors.white.withAlpha(140),
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.018,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          suffixIcon: InkWell(
            onTap: onTapIcon,
            child: Icon(suffixIcon, size: width * 0.060),
          ),

          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.withAlpha(153), // 0.6 * 255 = 153
            fontSize: width * 0.04,
          ),
        ),
      ),
    );
  }
}
