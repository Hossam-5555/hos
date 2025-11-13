import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/categoriesdata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/adminscreen/Home/AdminHome.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';
import 'package:hos/veiw/adminscreen/Home/categories/editcat.dart';

class ViewItemController extends GetxController {
  AdmindaTaCaregores admindata = AdmindaTaCaregores(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Itemsmodel> itemlist = [];

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
        itemlist.clear(); // فضي الليست القديمة
        itemlist.addAll(data.map((e) => Itemsmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  delete(String itemid, String imagename) {
    admindata.deletecat(itemid, imagename);

    itemlist.removeWhere((element) => element.itemsId == itemid);
    update();
  }

 GotoEditpage(Itemsmodel itemsmodel) {
  Get.to(
    () => const Editcat(),
    arguments: {"itemsmodel": itemsmodel},
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
