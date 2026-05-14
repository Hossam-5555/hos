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
  List<categoriesmodel2> categorylist = [];
  int selectedCat = 0; // لتتبع التصنيف المختار، -1 يعني لا يوجد تصنيف مختار
  void chnagecat(int index) {
    selectedCat = index;
    update();
  }

  TextEditingController controller = TextEditingController();
  @override
  void onInit() {
    super.onInit();

    viewallitems();
  }

  List<ItemsModel> get filtereditem {
    // إذا كان المختار هو "الكل" (افترضنا أن index 0 هو الكل)

    // الحصول على الـ id الخاص بالقسم المختار من قائمة الأقسام
    // نستخدم selectedCat كـ index للوصول للقسم الصحيح
    int selectedCategoryId = categorylist[selectedCat].id!;

    // إرجاع العناصر التي يطابق الـ categoryId الخاص بها الـ id المختار
    return itemlist
        .where((item) => item.categoryId == selectedCategoryId)
        .toList();
  }

  viewallitems() async {
    itemlist.clear(); // تنظيف القائمة قبل إضافة بيانات جديدة
    statusrequest = Statusrequest.loading;
    update();

    var response = await admindata.viewitem();
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        // حسب الـ JSON الخاص بك الحالة true وليس "success"

        List categories = response['data']; // هذه قائمة التصنيفات
        categorylist.addAll(
          categories.map((e) => categoriesmodel2.fromJson(e)),
        );
        for (var category in categories) {
          List itemsInCategory =
              category['items']; // استخراج المنتجات من داخل كل تصنيف

          // تحويل المنتجات إلى Model وإضافتها للقائمة الكبيرة
          itemlist.addAll(itemsInCategory.map((e) => ItemsModel.fromJson(e)));
        }

        if (itemlist.isEmpty) {
          statusrequest =
              Statusrequest.failure; // إذا لم توجد منتجات في أي تصنيف
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
