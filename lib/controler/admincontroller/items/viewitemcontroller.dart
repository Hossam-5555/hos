import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/adminscreen/admin_homescreen.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/additem.dart';
import 'package:hos/veiw/wedget/Admin/filteradmin.dart';

class ViewItemController extends GetxController {
  Admindataitem admindata = Admindataitem(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.find();

  bool get isarabic => myservisec.sharedPreferences.getString("lang") == "ar";

  List<ItemsModel> itemlist = []; // قائمة المنتجات للقسم المختار فقط
  CategoriesModel? catcodel;

  int selectedCat = -1;
  String? catname;

  TextEditingController search = TextEditingController();
  Future<void> onSearchSubmit() async {
    await viewCategoryItems(selectedCat);
  }

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

  Future<void> viewCategoryItems(int categoryId, {FilterResult? filter}) async {
    itemlist.clear();
    statusrequest = Statusrequest.loading;
    update();

    final response = await admindata.viewitem(
      categoryId.toString(),
      filter: filter,
      search: search.text,
      minLimit: 0,
      maxLimit: 1000,
    );

    if (response is! Map<String, dynamic>) {
      statusrequest = Statusrequest.failure;
      update();
      return;
    }

    statusrequest = handling(response);

    if (statusrequest == Statusrequest.success) {
      if (response['status'] == true) {
        final data = response['data'] ?? {};

        final List items = data['data'] ?? [];
        itemlist.addAll(items.map((e) => ItemsModel.fromJson(e)));

        final List brandsJson = data['brands'] ?? [];
        brands = brandsJson.map((b) => Brandmodel.fromjson(b)).toList();

        if (itemlist.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  FilterResult? _filter;
  List<Brandmodel> brands = [];
  Future<void> openFilter(BuildContext context) async {
    final result = await showFilterSheet(
      context,
      brands: brands,
      minLimit: 0,
      maxLimit: 1000,
      initial: _filter,
    );

    if (result == null) return; // المستخدم قفل الشيت من غير Apply

    _filter = result;
    await viewCategoryItems(selectedCat, filter: _filter);
  }

  void delete(int itemid) {
    admindata.deleteitem(itemid);

    itemlist.removeWhere((element) => element.id == itemid);
    update();
  }

  // void gotoeditpage(ItemsModel itemsmodel) {
  //   Get.to(() => EditItem(), arguments: {"itemsmodel": itemsmodel});
  // }

  // من صفحة الـ view
  Future<void> goToAddItem() async {
    final changed = await Get.to(
      () => ItemFormScreen(categoryId: selectedCat, categoryName: catname),
    );
    if (changed == true) viewCategoryItems(selectedCat);
  }

  Future<void> goToEditItem(ItemsModel m) async {
    final changed = await Get.to(() => ItemFormScreen(item: m));
    if (changed == true) viewCategoryItems(m.categoryId!);
  }

  void backtohomebage() {
    Get.offAll(
      AdminHome(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }
}
