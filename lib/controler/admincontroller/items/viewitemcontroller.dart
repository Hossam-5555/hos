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
  
  List<ItemsModel> itemlist = []; // قائمة المنتجات للقسم المختار فقط
  CategoriesModel? catcodel;
  
  int selectedCat = -1; 
  String? catname;
  
  TextEditingController controller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // استقبال القسم المختار من الشاشة السابقة
    catcodel = Get.arguments['catid'];
    selectedCat = catcodel!.id!;
    catname = catcodel!.name;
    
    // جلب المنتجات فور فتح الشاشة
    viewCategoryItems(selectedCat);
  }

  // دالة تغيير القسم من داخل الشاشة (لو الأدمن ضغط على قسم آخر)
  void chnagecat(int index) {
    selectedCat = index;
    update();
    // ✳️ بمجرد تغيير القسم، نمسح القديم ونجلب بيانات القسم الجديد
    viewCategoryItems(selectedCat); 
  }

  // ✳️ تم تغيير اسم الدالة ومنطقها لتجلب منتجات قسم واحد فقط
  Future<void> viewCategoryItems(int categoryId) async {
    itemlist.clear(); // مسح منتجات القسم القديم من الشاشة لتجنب التداخل
    statusrequest = Statusrequest.loading;
    update();

    // ⚠️ ملاحظة: تأكد أن دالة viewitem في ملف admindata تستقبل الـ categoryId وترسله للرابط
    var response = await admindata.viewitem(categoryId.toString());
    
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        
        // جلب المنتجات من داخل كائن القسم الراجع من السيرفر
        // افترضنا هنا أن Laravel يرجع المنتجات داخل key اسمه 'items'
        if (response['data']['items'] != null) {
          List items = response['data']['items'];
          itemlist.addAll(items.map((e) => ItemsModel.fromJson(e)));
        }

        // لو القسم فارغ ولا يوجد به منتجات
        if (itemlist.isEmpty) {
          statusrequest = Statusrequest.nodata;
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
    viewCategoryItems(selectedCat); // تحديث القائمة بعد إضافة منتج جديد
  }

  void backtohomebage() {
    Get.offAll(
      AdminHome(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }
}