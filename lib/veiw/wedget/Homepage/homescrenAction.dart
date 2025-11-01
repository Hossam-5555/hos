import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/screen/cartandcheckout/cart.dart';

class Homescrenaction extends StatelessWidget {
  const Homescrenaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // لإضافة مسافة قياسية من حافة الشاشة اليمنى
      padding: const EdgeInsets.only(right: 5.0),
      child: Hero(
        tag: "carttag", // تأكد أن هذا الـ tag فريد
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: MaterialButton(shape: CircleBorder(),
                child: SvgPicture.asset(Imageasset.cart,height: 25,width: 25,),
                onPressed: () {
                  Get.to(
                    () => ShoppingCartPage(),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 400),
                  );
                  ;
                },
              ),
            ),
            // Positioned(
            //   top: 1,
            //   right: 4,
            //   child: const Text(
            //     '5',
            //     style: TextStyle(
            //       color: Color.fromARGB(255, 157, 16, 16),
            //       fontSize: 15,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
