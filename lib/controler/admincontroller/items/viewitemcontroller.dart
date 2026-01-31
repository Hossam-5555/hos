import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/gotoanypage.dart';
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

  void delete(String itemid, String imagename) {
    admindata.deleteitem(itemid, imagename);
    itemlist.removeWhere((element) => element.itemsId.toString() == itemid);
    update();
  }

  final gotoanypage = Get.put(Gotoanypagecalss());
  void gotoeditpage(Itemsmodel itemsmodel) {
    gotoanypage.Gotoanypage(EditItem(), false, {"itemsmodel": itemsmodel});
  }

  void goToAddPage() async {
    await Get.to(() => Additem());
    viewallitems();
  }

  void backtohomebage() {
    Get.offAll(
      AdminHome(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }
}
