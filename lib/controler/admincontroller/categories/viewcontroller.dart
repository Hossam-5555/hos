import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/categoriesdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/adminscreen/Adminhomescreen.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';
import 'package:hos/veiw/adminscreen/Home/categories/editcat.dart';

class ViewCatController extends GetxController {
  AdmindaTaCaregores admindata = AdmindaTaCaregores(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<categoriesmodel2> catdata = [];

  @override
  void onInit() {
    super.onInit();
    viewCat();
  }

  Future<void> viewCat() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await admindata.viewcat();
    print("=============================== Controller $response");
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response["data"];

        /// ✳️ المهم هنا:
        catdata.clear(); // فضي الليست القديمة
        catdata.addAll(data.map((e) => categoriesmodel2.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void delete(int catid) {
    admindata.deletecat(catid);

    catdata.removeWhere((element) => element.id == catid);
    update();
  }

  void gotoeditpage(categoriesmodel2 catmodel) {
    Get.to(() => Editcat(), arguments: {"catmodel": catmodel});
  }

  void goToAddPage() async {
    /// ✳️ بعد ما ترجع من صفحة الإضافة، اعمل refresh تلقائي
    await Get.to(() => Addcategories());
    viewCat(); // أعد تحميل البيانات بعد العودة
  }

  void backtohomebage() {
    Get.offAll(
      AdminHome(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }
}
