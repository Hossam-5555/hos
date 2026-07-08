import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/items.dart';
import 'package:hos/data/model/brandmodel.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';

class ItemsController extends SearchMix {
  List<CategoriesModel> categories = [];
  int? selecteditem;
  int? selectedfilter;
  late String catid;
  List<ItemsModel> data = [];

  @override
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec1 = Get.find();
  Itemsdata itemdata = Itemsdata(Get.find());

  // ✳️ المتغيرات الجديدة التي تم إضافتها للـ Pagination:
  int currentPage = 1; // الصفحة الحالية
  bool hasMoreData = true; // هل توجد صفحات أخرى؟
  bool isLoadMore = false; // لتجنب إرسال طلبين في نفس الوقت أثناء التمرير

  void changcat(int val, String catigid) {
    selecteditem = val;
    catid = catigid;
    update(); // يحدث الواجهة مباشرة
    getitems(
      catid,
      isNewCategory: true,
    ); // ✳️ أضفنا علامة تفيد بتغيير القسم بالكامل
  }

  void filtesortedby(int val) {
    selectedfilter = val;
    update(); // يحدث الواجهة مباشرة
  }

  void initdata() {
    catid = Get.arguments['catid'];
    categories = Get.arguments["categories"];
    selecteditem = Get.arguments['selecteditem'] ?? 0; // قيمة افتراضية
    getitems(catid);
  }

  // ✳️ تم تعديل الدالة لاستقبال اختيارات التحديث والصفحات
  Future<void> getitems(
    String catid, {
    bool isRefresh = false,
    bool isNewCategory = false,
  }) async {
    // إذا قام المستخدم بالسحب للتحديث أو غير القسم، نعيد العدادات للبداية
    if (isRefresh || isNewCategory) {
      currentPage = 1;
      hasMoreData = true;
      isLoadMore = false;
    }

    // إذا وصلنا للنهاية أو جاري تحميل صفحة بالفعل، توقف
    if (!hasMoreData || isLoadMore) return;

    // حالة التحميل الكامل للشاشة تظهر فقط في الصفحة الأولى
    if (currentPage == 1) {
      data.clear(); // نمسح فقط لو بنبدأ من جديد
      statusrequest = Statusrequest.loading;
      update();
    } else {
      // إذا كنا في الصفحة 2 أو أكثر، نضع حالة تحميل خفيفة في الأسفل فقط
      isLoadMore = true;
      update();
    }

    // ⚠️ ملاحظة: يجب أن تعدل دالة 'postdata' داخل كود الـ ItemData لتستقبل الـ currentPage وتمرره للرابط كـ Query Parameter مثل (?page=1)
    var response = await itemdata.postdata(
      catid,
      page: currentPage, // ✳️ تمرير الصفحة الحالية
    );

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        // ✳️ استخراج البيانات بحسب الـ JSON المعقد الخاص بـ Laravel Resource
        List itemlist = response["data"]["data"];
        int lastPage = response["data"]["meta"]["last_page"];

        // تحويل البيانات وإضافتها للقائمة الحالية (بدون حذف العناصر القديمة)
        data.addAll(itemlist.map((e) => ItemsModel.fromJson(e)));

        // التحقق من حالة انتهاء البيانات
        if (currentPage >= lastPage) {
          hasMoreData = false; // وصلنا لآخر صفحة
        } else {
          currentPage++; // نجهز العداد للصفحة القادمة
        }

        if (data.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    // إعادة ضبط متغير التحميل الفرعي
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
  final double defaultMin = 0.0;
  final double defaultMax = 5000.0;

  var minPrice = 0.0.obs;
  var maxPrice = 5000.0.obs;
  var selectedSort = "newest".obs;
  var selectedBrands = <int>[].obs;
  Rx<int?> get selectedCategory => data[0].categoryId.obs;

  final allBrands = [
    // Electronics
    BrandItem(
      id: 1,
      name: "Apple",
      categoryId: 2,
      imageUrl:
          "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-drip-field-7.png",
    ),
    BrandItem(
      id: 2,
      name: "Samsung",
      categoryId: 2,
      imageUrl:
          "https://www.freepnglogos.com/uploads/samsung-logo-text-png-1.png",
    ),
    BrandItem(
      id: 3,
      name: "Sony",
      categoryId: 2,
      imageUrl: "https://www.freepnglogos.com/uploads/sony-logo-png-0.png",
    ),

    // Fashion
    BrandItem(
      id: 4,
      name: "Huwei",
      categoryId: 2,
      imageUrl:
          "https://www.freepnglogos.com/uploads/nike-logo-png/nike-logo-black-transparent-svg-png-24.png",
    ),
    BrandItem(
      id: 5,
      name: "reelme",
      categoryId: 2,
      imageUrl: "https://www.freepnglogos.com/uploads/adidas-logo-png-hd-2.png",
    ),
    BrandItem(
      id: 6,
      name: "xiaomi",
      categoryId: 2,
      imageUrl:
          "https://brandlogos.net/wp-content/uploads/2021/11/zara-logo.png",
    ),

    // Home
    BrandItem(
      id: 7,
      name: "Hp",
      categoryId: 1,
      imageUrl:
          "https://brandlogos.net/wp-content/uploads/2012/10/ikea-logo-vector.png",
    ),
  ];

  // دالة الفلترة تعتمد على selectedCategory.value مما يجعلها مراقبة
  List<BrandItem> get filteredBrands {
    return allBrands
        .where((brand) => brand.categoryId == selectedCategory.value)
        .toList();
  }

  int get activeFiltersCount {
    int count = 0;
    if (minPrice.value != defaultMin || maxPrice.value != defaultMax) count++;
    if (selectedSort.value != "newest") count++;
    if (selectedBrands.isNotEmpty) count++;
    if (selectedCategory.value != 0) count++;
    return count;
  }

  Map<String, dynamic> get filterParams => {
    "category_id": selectedCategory.value == 0 ? null : selectedCategory.value,
    "min_price": minPrice.value.round(),
    "max_price": maxPrice.value.round(),
    "sort_by": selectedSort.value,
    "brands": selectedBrands.toList(),
  };

  void toggleBrand(int brandId) {
    if (selectedBrands.contains(brandId)) {
      selectedBrands.remove(brandId);
    } else {
      selectedBrands.add(brandId);
    }
  }

  void selectCategory(int categoryId) {
    selectedCategory.value = categoryId;
    selectedBrands.clear();
  }

  void reset() {
    minPrice.value = defaultMin;
    maxPrice.value = defaultMax;
    selectedSort.value = "newest";
    selectedBrands.clear();
    selectedCategory.value = 0;
  }
}
