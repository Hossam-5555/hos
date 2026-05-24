import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/veiw/adminscreen/Home/AdminHome.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminpending.dart';

class Adminhome extends GetxController {

  TextEditingController searchcontroller =
      TextEditingController();

  int currentpage = 0;

  PageController controller = PageController();

  // 👇 عند الضغط على BottomNavigationBar
  void changePage(int index) {

    currentpage = index;

    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    update();
  }

  // 👇 لما الصفحة تتغير
  void onpagechanged(int index) {

    currentpage = index;

    update();
  }

  List<Widget> pages = [
    AdminHome2(),
    Adminpending(),
    // ViewItemScreen(),
    ViewCategories(),
  ];
  List time=["day","mounth","year"];
   
  List<List<dynamic>> title = [
    ["Dashboard", Icons.home_outlined],
    ["Orders", Icons.card_giftcard],
    ["Categories", Icons.category_outlined],
  ];
}