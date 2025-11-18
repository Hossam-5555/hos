import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/viewitem.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminorderscrean.dart';
import 'package:hos/veiw/userscreen/screen/auth/login.dart';

class adminHomecontroller extends GetxController {
  Myservisec myservisec = Get.put(Myservisec());

  gotocategories() {
    Get.to(
      () => ViewCategories(),
      duration: Duration(milliseconds: 700),
      transition: Transition.fadeIn,
    );
  }

  gotoitemsview() {
    Get.to(
      () => viewitem(),
      duration: Duration(milliseconds: 700),
      transition: Transition.fadeIn,
    );
  }

  logout() {
    myservisec.sharedPreferences.clear();
    Get.to(
      () => Login(),
      duration: Duration(milliseconds: 700),
      transition: Transition.fadeIn,
    );
  }

  GotoOrder() {
    Get.to(
      () => orderscreen(),
      duration: Duration(milliseconds: 700),
      transition: Transition.fadeIn,
    );
  }
}
