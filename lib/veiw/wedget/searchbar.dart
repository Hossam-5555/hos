import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Searchbar extends StatelessWidget {
  void Function()? onPressedIcon;
  final Function(String)? onChanged;
  final TextEditingController mycontroller;
  String title;
  Searchbar({
    super.key,
    this.onPressedIcon,
    required this.title,
    this.onChanged, required this.mycontroller,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      child: TextFormField(
        controller: mycontroller,
        onChanged: onChanged,
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
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
