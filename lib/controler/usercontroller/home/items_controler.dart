import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/items.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';

class ItemsControler extends SearchMix {
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
  int currentPage = 1;      // الصفحة الحالية
  bool hasMoreData = true;   // هل توجد صفحات أخرى؟
  bool isLoadMore = false;   // لتجنب إرسال طلبين في نفس الوقت أثناء التمرير

  void changcat(int val, String catigid) {
    selecteditem = val;
    catid = catigid;
    update(); // يحدث الواجهة مباشرة
    getitems(catid, isNewCategory: true); // ✳️ أضفنا علامة تفيد بتغيير القسم بالكامل
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
  Future<void> getitems(String catid, {bool isRefresh = false, bool isNewCategory = false}) async {
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
      myservisec1.sharedPreferences.getInt("id")!,
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

  List<String> filterdata = [
    "On Sale",
    "Featured",
    "Date: Latest",
    "Date: oldest",
    "Price: Low to High",
    "Price: High to Low",
  ];

  RxInt price = 50.obs;

  @override
  void onInit() {
    search = TextEditingController();
    initdata();
    super.onInit();
  }
}