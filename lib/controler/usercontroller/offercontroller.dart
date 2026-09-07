import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/offerdata.dart';
import 'package:hos/data/model/itemsmodel.dart';

class Offercontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.put(Myservisec());
  Offerdata notificationdata = Get.put(Offerdata(Get.find()));
  List<ItemsModel> offerList = [];

  /// الكاتيجوري المختارة حاليًا من الـ Chips (null = "الكل")
  int? selectedCategoryId;

  Future<void> getoffer() async {
    offerList.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await notificationdata.getdata();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response["data"];
        offerList.addAll(data.map((e) => ItemsModel.fromJson(e)).toList());
        if (offerList.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void selectCategory(int? categoryId) {
    selectedCategoryId = categoryId;
    update();
  }

  /// المنتجات بعد تطبيق فلتر الكاتيجوري (أو الكل لو مفيش اختيار)
  List<ItemsModel> get filteredOffers {
    if (selectedCategoryId == null) return offerList;
    return offerList.where((e) => e.categoryId == selectedCategoryId).toList();
  }

  /// قائمة الكاتيجوريز الحقيقية المستخرجة من المنتجات اللي رجعت من الباك اند
  List<Brandmodel> get availableCategories {
    final Map<int, String> map = {};
    for (final item in offerList) {
      if (item.categoryId != null) {
        map[item.categoryId!] = item.categoryNameAr ?? item.categoryName ?? '';
      }
    }
    return map.entries
        .map((e) => Brandmodel(id: e.key, name: e.value))
        .toList();
  }

  /// عروض هتنتهي قريبًا - فقط المنتجات اللي فعلاً عندها offerEndsAt من الباك اند
  List<ItemsModel> get endingSoonOffers {
    final list = offerList.where((e) => e.categoryName != null).toList();
    list.sort((a, b) => a.itemsActive!.compareTo(b.itemsActive!));
    return list;
  }

  /// أفضل العروض - أعلى نسبة خصم من ضمن الفلتر الحالي
  List<ItemsModel> get bestOffers {
    final list = List<ItemsModel>.from(filteredOffers);
    list.sort((a, b) => (b.itemsDiscount ?? 0).compareTo(a.itemsDiscount ?? 0));
    return list;
  }

  /// تجميع العروض حسب الكاتيجوري لعرض قسم لكل قسم
  Map<int, List<ItemsModel>> get offersGroupedByCategory {
    final Map<int, List<ItemsModel>> grouped = {};
    for (final item in offerList) {
      if (item.categoryId == null) continue;
      grouped.putIfAbsent(item.categoryId!, () => []).add(item);
    }
    return grouped;
  }

  List<ItemsModel> skeletonData = List.generate(
    6,
    (index) => ItemsModel(
      id: 0,
      itemsName: "اسم المنتج يظهر هنا", // نص بطول متوسط
      itemsPrice: 1000,
      priceAfterDiscount: 800,
      itemsImage: "", // اتركها فارغة، السكيليتون سيرسم مربعاً مكانها
      itemsDiscount: 10,
      isFavorite: false,
    ),
  );

  @override
  void onInit() {
    getoffer();
    super.onInit();
  }
}
