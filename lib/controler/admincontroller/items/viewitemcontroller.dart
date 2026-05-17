import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/adminscreen/Adminhomescreen.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/additem.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/edititem.dart';

class ViewItemController extends GetxController {
  admindataitem admindata = admindataitem(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<ItemsModel> itemlist = [];
  List<CategoriesModel> categorylist = [];
  CategoriesModel? catcodel;
  int selectedCat = -1; // لتتبع التصنيف المختار، -1 يعني لا يوجد تصنيف مختار
  void chnagecat(int index) {
    selectedCat = index;
    update();
  }
  String? catname;
  TextEditingController controller = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    catcodel = Get.arguments['catid'];
    selectedCat = catcodel!.id!;
    catname = catcodel!.name;
    print(selectedCat);
    ViewAllItems();
  }

  List<ItemsModel> get filtereditem {
    if (categorylist.isEmpty) return [];

    return itemlist.where((item) => item.categoryId == selectedCat).toList();
  }

  Future<void> ViewAllItems() async {
    categorylist.clear();
    itemlist.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await admindata.viewitem();
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List categories = response['data'];

        // 1. تحويل وإضافة التصنيفات باستخدام map عادي
        categorylist.addAll(categories.map((e) => CategoriesModel.fromJson(e)));

        // 2. 🚀 السحر هنا: استخدام map مع expand لتجميع كل المنتجات في سطر واحد بدون for
        itemlist.addAll(
          categories
              .where(
                (category) => category['items'] != null,
              ) // التأكد إن التصنيف جواه منتجات
              .expand(
                (category) => (category['items'] as List).map(
                  (e) => ItemsModel.fromJson(e),
                ),
              ),
        );

        if (itemlist.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  void delete(String itemid, String imagename) {
    admindata.deleteitem(itemid, imagename);
    itemlist.removeWhere((element) => element.id.toString() == itemid);
    update();
  }

  void gotoeditpage(ItemsModel itemsmodel) {
    Get.to(() => EditItem(), arguments: {"itemsmodel": itemsmodel});
  }

  void goToAddPage() async {
    await Get.to(() => Additem(), arguments: {"catid": selectedCat, "catname": catname});
    ViewAllItems();
  }

  void backtohomebage() {
    Get.offAll(
      AdminHome(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }
}
