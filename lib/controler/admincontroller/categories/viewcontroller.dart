import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/remote/admindata/categoriesdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/adminscreen/Home/AdminHome.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';
import 'package:hos/veiw/adminscreen/Home/categories/editcat.dart';

class ViewCatController extends GetxController {
  AdmindaTaCaregores admindata = AdmindaTaCaregores(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<categoriesmodel> catdata = [];

  @override
  void onInit() {
    super.onInit();
    viewCat();
  }

  Future<void> viewCat() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await admindata.viewcat();
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        print(response);
        List data = response["data"];

        /// ✳️ المهم هنا:
        catdata.clear(); // فضي الليست القديمة
        catdata.addAll(data.map((e) => categoriesmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  delete(String catid, String imagename) {
    admindata.deletecat(catid, imagename);

    catdata.removeWhere((element) => element.categoriesId == catid);
    update();
  }

 GotoEditpage(categoriesmodel catmodel) {
  Get.to(
    () => const Editcat(),
    arguments: {"catmodel": catmodel},
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );
}


  void goToAddPage() async {
    /// ✳️ بعد ما ترجع من صفحة الإضافة، اعمل refresh تلقائي
    await Get.to(() => Addcategories());
    viewCat(); // أعد تحميل البيانات بعد العودة
  }

  backtohomebage() {
    Get.offAll(
      AdminHome(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }
}
