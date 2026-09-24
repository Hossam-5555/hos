import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/items.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';
// تأكد من استدعاء مسار موديل البراند الصحيح
// import 'package:hos/data/model/brandmodel.dart';

class ItemsController extends SearchMix {
  List<CategoriesModel> categories = [];
  int? selecteditem;
  int? selectedfilter;
  late String catid;
  List<ItemsModel> data = [];
  List<Brandmodel> brands = []; // تأكد أن Brandmodel معرف بشكل صحيح
  int indexofcategrry = 0;
  @override
  // ignore: overridden_fields
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec1 = Get.find();
  Itemsdata itemdata = Itemsdata(Get.find());

  int currentPage = 1;
  bool hasMoreData = true;
  bool isLoadMore = false;

  // ---------------- متغيرات الفلترة ---------------- //
  final double defaultMin = 0.0;
  final double defaultMax = 5000.0;

  var minPrice = 0.0.obs;
  var maxPrice = 5000.0.obs;
  var selectedSort = "newest".obs;
  var selectedBrands = <int>[].obs;

  // تم تحويله إلى متغير تفاعلي حقيقي لتجنب الأخطاء
  var selectedCategory = 0.obs;

  void changcat(int val, String catigid) {
    selecteditem = val;
    catid = catigid;
    selectedCategory.value =
        int.tryParse(catigid) ?? 0; // نحدث الـ Category الخاص بالفلتر

    // تصفير الفلاتر عند تغيير القسم
    minPrice.value = defaultMin;
    maxPrice.value = defaultMax;
    selectedSort.value = "newest";
    selectedBrands.clear();
    selectedfilter = null;

    update();
    getitems(catid, isNewCategory: true);
  }

  void filtesortedby(int val) {
    selectedfilter = val;
    update();
  }

  void initdata() {
    catid = Get.arguments['catid'];
    categories = Get.arguments["categories"] ?? [];
    selecteditem = Get.arguments['selecteditem'] ?? 0;
    selectedCategory.value = int.tryParse(catid) ?? 0; // إعطاء قيمة مبدئية

    getitems(catid);
  }

  // دالة لتطبيق الفلاتر والبحث من جديد
  void applyFilters() {
    getitems(catid, isRefresh: true);
    Get.back();
  }

  Future<void> getitems(
    String catid, {
    bool isRefresh = false,
    bool isNewCategory = false,
  }) async {
    if (isRefresh || isNewCategory) {
      currentPage = 1;
      hasMoreData = true;
      isLoadMore = false;
    }

    if (!hasMoreData || isLoadMore) return;

    if (currentPage == 1) {
      data.clear();
      // نمسح البراندات فقط لو دخلنا قسم جديد، عشان متختفيش وقت الفلترة
      if (isNewCategory) {
        brands.clear();
      }
      statusrequest = Statusrequest.loading;
      update();
    } else {
      isLoadMore = true;
      update();
    }

    var response = await itemdata.postdata({
      "category_id": catid,
      "brands": selectedBrands.toList(),
      "min_price": minPrice.value.round(),
      "max_price": maxPrice.value.round(),
      "sort_by": selectedSort.value,
    }, page: currentPage);
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List itemlist = response["data"]["data"];
        int lastPage = response["data"]["meta"]["last_page"];

        // التحقق من وجود البراندات لتفادي أخطاء الـ Null
        if (response["data"]["brands"] != null) {
          List brandList = response["data"]["brands"];
          brands.addAll(brandList.map((e) => Brandmodel.fromjson(e)));
        }
        data.addAll(itemlist.map((e) => ItemsModel.fromJson(e)));
        if (currentPage >= lastPage) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        if (data.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    isLoadMore = false;
    update();
  }

  RxInt price = 50.obs;

  @override
  void onInit() {
    search = TextEditingController();
    initdata();
    super.onInit();
  }

  // إرجاع قائمة البراندات كما جلبها الـ API للقسم الحالي
  List<Brandmodel> get filteredBrands {
    return brands;
  }

  int get activeFiltersCount {
    int count = 0;
    if (minPrice.value != defaultMin || maxPrice.value != defaultMax) count++;
    if (selectedSort.value != "newest") count++;
    if (selectedBrands.isNotEmpty) count++;
    return count;
  }

  void toggleBrand(int brandId) {
    if (selectedBrands.contains(brandId)) {
      selectedBrands.remove(brandId);
    } else {
      selectedBrands.add(brandId);
    }
    update();
  }

  void selectCategory(int categoryId) {
    selectedCategory.value = categoryId;
    selectedBrands.clear();
  }

  void resetFilters() {
    minPrice.value = defaultMin;
    maxPrice.value = defaultMax;
    selectedSort.value = "newest";
    selectedBrands.clear();
    // بعد ما صفرنا القيم، نحدث البيانات
    applyFilters();
  }
}