import 'package:flutter/material.dart';
import 'package:hos/core/conistant/appcolor.dart';

// ignore: must_be_immutable
class Textfealdauth extends StatelessWidget {
  Textfealdauth({
    super.key,
    this.obscureText,
    this.onTapIcon,
    required this.label,
    required this.suffixIcon,
    required this.hint,
    required this.textEditingController,
    required this.valid,
  });
  TextEditingController textEditingController;
  final String label, hint;
  late IconData suffixIcon;
  String? Function(String?)? valid;
  void Function()? onTapIcon;
  bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText == null || obscureText == false ? false : true,
      validator: valid,
      controller: textEditingController,
      decoration: InputDecoration(
        contentPadding: EdgeInsetsGeometry.only(left: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color.fromARGB(255, 22, 186, 49)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 65, 221, 229),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: InkWell(
          onTap: onTapIcon,
          child: Icon(
            suffixIcon,
            color: const Color.fromARGB(255, 36, 172, 12),
          ),
        ),
        label: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            label,
            style: TextStyle(color: const Color.fromARGB(255, 10, 9, 10)),
          ),
        ),
        hint: Text(
          hint,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black26),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Appcolor.black.withAlpha(40)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
