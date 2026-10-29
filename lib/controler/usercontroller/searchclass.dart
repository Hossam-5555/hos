import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/binding.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/homedata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/itemsdetailes.dart';

class SearchMix extends GetxController {
  List<ItemsModel> searchlist = [];
  Statusrequest statusrequest = Statusrequest.none;
  TextEditingController? search;
  Homedata homedata = Homedata(Get.find());

  bool issearch = false;
  TextInputAction textInputAction = TextInputAction.search;
  bool get isarabic => myservisec.sharedPreferences.getString("lang") == "ar";

  FocusNode focusNode = FocusNode();
  int currentSearchPage = 1;
  bool hasMoreSearchData = true;
  bool isSearchLoadingMore = false;
  int _searchToken = 0; // يلغي أي رد قديم لما يبدأ بحث جديد
 Future<void> getsearchdata({bool isRefresh = false}) async {
  final query = search?.text.trim() ?? '';
  if (query.isEmpty) return;

  if (isRefresh) {
    _searchToken++;
    currentSearchPage = 1;
    hasMoreSearchData = true;
    isSearchLoadingMore = false;
  }

  if (!hasMoreSearchData || isSearchLoadingMore) return;

  final int token = _searchToken;
  final bool isFirstPage = currentSearchPage == 1;

  if (isFirstPage) {
    searchlist.clear();
    statusrequest = Statusrequest.loading;
  } else {
    isSearchLoadingMore = true;
  }
  update();

  final response = await homedata.searchdata(query, page: currentSearchPage);

  // بحث جديد بدأ أثناء الانتظار: تجاهل الرد القديم
  if (token != _searchToken) return;

  final status = handling(response);

  if (status == Statusrequest.success && response["status"] == true) {
    final List body = response["data"]["data"];
    final int lastPage = response["data"]["meta"]["last_page"];

    searchlist.addAll(body.map((e) => ItemsModel.fromJson(e)));

    if (currentSearchPage >= lastPage) {
      hasMoreSearchData = false;
    } else {
      currentSearchPage++;
    }

    statusrequest =
        searchlist.isEmpty ? Statusrequest.nodata : Statusrequest.success;
    focusNode.unfocus();
  } else if (isFirstPage) {
    // الفشل بيأثر على الشاشة بس في الصفحة الأولى
    statusrequest =
        status == Statusrequest.success ? Statusrequest.failure : status;
  }
  // فشل في صفحة تانية: نسيب النتائج الحالية زي ما هي

  isSearchLoadingMore = false;
  update();
}
  void checksearch(String val) {
    if (val.trim().isEmpty) {
      _searchToken++;
      issearch = false;
      focusNode.unfocus();
      searchlist.clear();
      currentSearchPage = 1;
      hasMoreSearchData = true;
      isSearchLoadingMore = false;
      statusrequest = Statusrequest.none;
    }
    update();
  }

  @override
  void onInit() {
    getRecentSearches();
    search = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    search?.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onsearch() {
    if (search == null || search!.text.trim().isEmpty) {
      // print("تم الضغط على البحث بدون كتابة نص");
      return;
    }

    issearch = true;
    getsearchdata(isRefresh: true); // كل بحث جديد يبدأ من الصفحة 1
  }

  void gotoitemsdatails(ItemsModel itemsmodel) {
    Get.to(
      () => Itemsdetailes(),
      binding: ItemDetailsBinding(),

      transition: Transition.cupertino,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 400),
      arguments: {"itemsmodel": itemsmodel},
    );
  }

  List<String> recentSearches = [];
  Myservisec myservisec = Get.put(Myservisec());
  void getRecentSearches() {
    recentSearches =
        myservisec.sharedPreferences.getStringList("recent_searches") ?? [];
    update();
  }

  // 2. إضافة كلمة بحث جديدة (بنستدعيها لما اليوزر يدوس بحث)
  void addToRecentSearches(String query) {
    if (query.trim().isEmpty) return;

    // بنمسح الكلمة لو موجودة قبل كده عشان نضيفها في الأول (تحديث مكانها)
    recentSearches.remove(query);

    // بنضيف الكلمة الجديدة في أول القائمة
    recentSearches.insert(0, query);

    // بنحدد عدد الكلمات المحفوظة بـ 10 كلمات بس كحد أقصى عشان الشكل
    if (recentSearches.length > 10) {
      recentSearches = recentSearches.sublist(0, 10);
    }

    // بنحفظ القائمة الجديدة في SharedPreferences
    myservisec.sharedPreferences.setStringList(
      "recent_searches",
      recentSearches,
    );
    update();

    // هنا هتحط كود البحث الفعلي في الـ API بتاعك
    // searchData(query);
  }

  // 3. مسح سجل البحث (لو حابب تضيف زرار "مسح الكل")
  void clearRecentSearches() {
    recentSearches.clear();
    myservisec.sharedPreferences.remove("recent_searches");
    update();
  }
}