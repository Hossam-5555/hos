import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/userdata/auth/veryvicodesign.dart';

class veryfisigncontroler extends GetxController {
  String? email;
  veryficodesignupdata veryficodesign = veryficodesignupdata(Get.find());
  Statusrequest statusrequest = Statusrequest.none;

  gotoSuccessignup(String verifycode) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await veryficodesign.postdata(email!, verifycode);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        Get.snackbar("success", "تم انشاء حساب بنجاح");
            Get.offAllNamed(Approute.login);

      } else {
        Get.defaultDialog(
          title: "Warning",
          middleText: "veryfi code not correct",
        );
      }
      update();
    }
  }



  resendcode() {
    veryficodesign.resend(email!);
  }

  @override
  void onInit() {
    email = Get.arguments['email'];
    super.onInit();
  }
}
