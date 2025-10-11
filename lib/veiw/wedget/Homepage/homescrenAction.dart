import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/veiw/screen/cartandcheckout/cart.dart';

class Homescrenaction extends StatelessWidget {
  const Homescrenaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // لإضافة مسافة قياسية من حافة الشاشة اليمنى
      padding: const EdgeInsets.only(right: 16.0),
      child: Hero(
        tag: "carttag", // تأكد أن هذا الـ tag فريد
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 26),
                onPressed: () {
                  Get.to(
                    () => ShoppingCartPage(),
                    transition: Transition.fadeIn,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 400),
                  );
                  ;
                },
              ),
            ),
            Positioned(
              top: 1,
              right: 5,
              child: const Text(
                '5',
                style: TextStyle(
                  color: Color.fromARGB(255, 157, 16, 16),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
