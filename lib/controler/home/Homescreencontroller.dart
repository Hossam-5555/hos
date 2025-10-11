import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/veiw/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/screen/home/Homepage.dart';
import 'package:hos/veiw/screen/myfavorite.dart';

class Homescreencontroller extends GetxController {
  // ignore: non_constant_identifier_names
  int Currentpage = 0;

  void changpage(int i) {
    Currentpage = i;
    update();
  }

  void gotoshoppage() {
    Get.to(
      () => ShoppingCartPage(),
      transition: Transition.fadeIn,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 320),
    );
  }

  final List<Widget> pages = [
    HomePage(), // 🔹 صفحة الهوم
    Myfavorite(), // 🔹 صفحة المفضلة
    Column(children: [Center(child: Text("fuck you"))]),
  ];

  var x = 20.0.obs;
  var y = 500.0.obs;

  void fun(DragUpdateDetails details) {
    x.value += details.delta.dx;
    y.value += details.delta.dy;
  }

  List<List<dynamic>> Appbartitle = [
    ['FASHION', Icons.home],
    ['Favorite', Icons.favorite_border],
    ['Profile', Icons.person_outline_rounded],
  ];
}
