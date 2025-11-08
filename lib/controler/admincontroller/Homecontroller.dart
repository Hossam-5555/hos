import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';

class adminHomecontroller extends GetxController {
  Myservisec myservisec = Get.put(Myservisec());

  gotocategories() {
    Get.to(
      () => viewcategories(),
      duration: Duration(milliseconds: 700),
      transition: Transition.fadeIn,
    );
  }
}
