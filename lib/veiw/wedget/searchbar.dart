import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Searchbar extends StatelessWidget {
  void Function()? onPressedIcon;
  final Function(String)? onChanged;
  final TextEditingController mycontroller;
  String title;
  final TextInputAction? textInputAction;

  FocusNode? focusNode ;
  Searchbar({
    super.key,
    this.onPressedIcon,
    required this.title,
    this.onChanged,
    required this.mycontroller,
    this.textInputAction ,
     this.focusNode
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 2.5,
      child: TextFormField(focusNode: focusNode,
        textInputAction: textInputAction,
        controller: mycontroller,
        onChanged: onChanged,
        onFieldSubmitted: (value) {
          onPressedIcon!();
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            color: Colors.grey,
            onPressed: onPressedIcon,
          ),
          filled: true,
          fillColor: Colors.white.withAlpha(25),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
