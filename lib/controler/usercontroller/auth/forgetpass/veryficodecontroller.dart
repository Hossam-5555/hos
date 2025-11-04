import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/remote/userdata/auth/forgetpass/verifycode.dart';

class veryficontroler extends GetxController {
  String? email;
  Statusrequest statusrequest=Statusrequest.none;
  VerifyCodeForgetpassdata verifyCodeForgetpassdata = VerifyCodeForgetpassdata(
    crud: Get.find(),
  );
  chekCode(String verifycode) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await verifyCodeForgetpassdata.postdata(email!, verifycode);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        // data.addAll(response['data']);
        Get.offNamed(Approute.Resetpass, arguments: {"email": email});
      } else {
        Get.defaultDialog(
          title: "Warning",
          middleText: "veryfi code not correct",
        );
        statusrequest = Statusrequest.failure;
      }
      update();
    }
  }

  @override
  void onInit() {
    email = Get.arguments['email'];
    super.onInit();
  }
}
