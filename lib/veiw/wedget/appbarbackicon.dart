import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Appbarbackicon extends StatelessWidget {
  Appbarbackicon({super.key, required this.title, required this.herotag});
  final String title;
  final String herotag;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              iconSize: 24,
              splashRadius: 24,
            ),
          ),
        ),
      ),
    );
  }
}
