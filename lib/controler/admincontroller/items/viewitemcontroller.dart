import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/adminscreen/Home/AdminHome.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/additem.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/edititem.dart';

class ViewItemController extends GetxController {
  admindataitem admindata = admindataitem(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Itemsmodel> itemlist = [];

  @override
  void onInit() {
    super.onInit();
    viewallitems();
  }

  Future<void> viewallitems() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await admindata.viewitem();
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
    // admindata.deleteitem(itemid, imagename);

    itemlist.removeWhere((element) => element.itemsId == itemid);
    update();
  }

  GotoEditpage(Itemsmodel itemsmodel) {
    Get.to(
      () => const EditItem(),
      arguments: {"itemsmodel": itemsmodel},
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  void goToAddPage() async {
    /// ✳️ بعد ما ترجع من صفحة الإضافة، اعمل refresh تلقائي
    await Get.to(() => Additem());
    viewallitems(); // أعد تحميل البيانات بعد العودة
  }

  backtohomebage() {
    Get.offAll(
      AdminHome(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }
}
