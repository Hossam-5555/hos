import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/binding.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/homedata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/itemsdetailes.dart';

class SearchMix extends GetxController {
  List<ItemsModel1> searchlist = [];
  Statusrequest statusrequest = Statusrequest.none;
  TextEditingController? search;
  Homedata homedata = Homedata(Get.find());

  bool issearch = false;
  TextInputAction textInputAction = TextInputAction.search;

  FocusNode focusNode = FocusNode();

  Future<void> getsearhdata() async {
    if (search == null || search!.text.trim().isEmpty) {
      return;
    }

    searchlist.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await homedata.searchdata(search!.text);
    // print("Response==========================: $response");

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response["status"] == true) {
        List responsebody = response['data'];
        searchlist.addAll(responsebody.map((e) => ItemsModel1.fromJson(e)));

        focusNode.unfocus();
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void checksearch(String val) {
    if (val.isEmpty) {
      issearch = false;
      focusNode.unfocus();
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
    super.dispose();
  }

  void onsearch() {
    if (search == null || search!.text.trim().isEmpty) {
      // print("تم الضغط على البحث بدون كتابة نص");
      return;
    }

    issearch = true;
    getsearhdata();
    update();
  }

  void gotoitemsdatails(ItemsModel1 itemsmodel) {
    Get.to(
      () => Itemsdetailes(),
      binding: ItemDetailsBinding(),

      transition: Transition.fadeIn,
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
