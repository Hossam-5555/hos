import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';

class Successsigncontroller extends GetxController {
  //go to login 
  Statusrequest statusrequest=Statusrequest.none;
  void gotologin() {
    Get.offAllNamed(Approute.login);
  }
}
