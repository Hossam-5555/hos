import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Appbarbackicon extends StatelessWidget {
  Appbarbackicon({
    super.key,
    required this.title,
    required this.herotag,
    this.selected,
    this.onPressed,
    this.iconButton,
  });
  final String title;
  final String herotag;
  bool? selected;
  void Function()? onPressed;
  var iconButton;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        selected == true ?
         iconButton : SizedBox.shrink()
        ],
      title: Text(title),
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Hero(
          tag: herotag,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: selected == true ? onPressed : () => Get.back(),
              icon: Icon(selected == true ? Icons.close : Icons.arrow_back),
              iconSize: 24,
              splashRadius: 24,
            ),
          ),
        ),
      ),
    );
  }
}
