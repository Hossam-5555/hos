import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/remote/admindata/categoriesdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class viewcatcontroller extends GetxController {
  admindatacaregores admindata = admindatacaregores(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<categoriesmodel> catdata = [];
  viewcat() async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await admindata.viewcat();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List data = response["data"];
        catdata.addAll(data.map((e) => categoriesmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
      update();
    }
  }

  void gotoeditpage() {
    Get.offAllNamed(Approute.login);
  }

  @override
  void onInit() {
    viewcat();
    super.onInit();
  }
}
