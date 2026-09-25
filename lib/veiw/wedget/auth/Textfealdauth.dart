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
    this.phone = false,
  });
  Textfealdauth.phone({
    super.key,
    this.obscureText,
    this.onTapIcon,
    required this.suffixIcon,
    required this.hint,
    required this.textEditingController,
    required this.valid,
    required this.phone,
  });
  TextEditingController textEditingController;
  String hint;
  late IconData suffixIcon;
  String? Function(String?)? valid;
  void Function()? onTapIcon;
  bool? obscureText;
  bool phone;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: TextFormField(
        keyboardType: phone ? TextInputType.phone : TextInputType.text,
        style: TextStyle(
          fontSize: width * 0.045, // حجم الخط متناسب مع العرض
          fontWeight: FontWeight.w500,
        ),
        obscureText: obscureText ?? false,
        validator: valid,
        controller: textEditingController,
        decoration: InputDecoration(
          filled: true,

          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.018,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
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
