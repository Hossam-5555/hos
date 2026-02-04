import 'package:flutter/material.dart';
import 'package:hos/core/conistant/appcolor.dart';

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
          color: const Color.fromARGB(255, 10, 10, 10),
          fontSize: width * 0.045, // حجم الخط متناسب مع العرض
          fontWeight: FontWeight.w500,
        ),
        obscureText: obscureText ?? false,
        validator: valid,
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.018,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 22, 186, 49),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Appcolor.black.withAlpha(40)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 65, 221, 229),
            ),
          ),
          suffixIcon: InkWell(
            onTap: onTapIcon,
            child: Icon(
              suffixIcon,
              size: width * 0.060,
              color: const Color.fromARGB(255, 10, 10, 10),
            ),
          ),

          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withAlpha(153), // 0.6 * 255 = 153
            fontSize: width * 0.04,
          ),
        ),
      ),
    );
  }
}
