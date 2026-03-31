// ignore_for_file: overridden_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/binding.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/homedata.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/items.dart';
import 'package:hos/veiw/userscreen/screen/home/itemsdetailes.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';

class HomepageController extends GetxController {
  Myservisec myservisec = Get.put(Myservisec());
  String? username;
  List<Itemsmodel> items = [];
  List<categoriesmodel> categories = [];
  Statusrequest statusrequest = Statusrequest.none;

  Homedata homedata = Homedata(Get.find());

  Future<void> getdata() async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await homedata.postdata();
    // print("Response==========================: $response");
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        List categorylist = response["categories"];
        categories.addAll(categorylist.map((e) => categoriesmodel.fromJson(e)));
        List itmeslist = response["items"];
        items.addAll(itmeslist.map((e) => Itemsmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void gotoitems(List categories, int selecteditem, String catid) {
    Get.to(
      () => Items(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 400),
      arguments: {
        'categories': categories,
        'selecteditem': selecteditem,
        "catid": catid,
      },
    );

    update();
  }

  void gotoitemsdatails(Itemsmodel itemsmodel) {
    Get.to(
      () => Itemsdetailes(),
      binding: ItemDetailsBinding(),

      transition: Transition.fade,
      curve: Curves.easeInOutQuint,
      duration: Duration(milliseconds: 400),
      arguments: {"itemsmodel": itemsmodel},
    );
  }
  //==================================================cart

  final List<OfferModel> offers = [
    OfferModel(
      image: "https://i.pinimg.com/webp/1200x/34/6e/7a/346e7ac45123572b94af0843a37a19d9.webp",
      title: 'عرض الصيف',
      description: 'اشتري قطعة واحصل على الثانية بنصف الثمن.',
      discount: 'خصم 50%',
      colors: const [
        Color.fromARGB(255, 19, 3, 0),
        Colors.white
      ], // برتقالي وزهري
    ),
    OfferModel(
      image:
          "https://i.pinimg.com/736x/81/b1/a2/81b1a2ea2ace6297da864a42fe014d98.jpg",
      title: 'عروض التقنية',
      description: 'أفضل الخصومات على الهواتف والسماعات الذكية.',
      discount: 'خصم 30%',
      colors: const [
        Color.fromARGB(255, 19, 0, 4),
        Color.fromARGB(255, 32, 1, 1),
      ], // أخضر متدرج
    ),
    OfferModel(
      image:
          "https://i.pinimg.com/webp/1200x/49/bb/12/49bb129c93b7d6454a2e34504be5e488.webp",
      title: 'تصفية نهاية العام',
      description: 'لا تفوت الفرصة! الكمية محدودة جداً.',
      discount: 'خصم يصل لـ 70%',
      colors: const [
        Color.fromARGB(255, 7, 6, 6),
        Color.fromARGB(255, 204, 200, 198),
      ], // أزرق وبنفسجي
    ),
  ];

  int currentIndex = 0;
  Timer? timer;

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      currentIndex = (currentIndex + 1) % offers.length;
      // print("Hossam");
      update();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  // داخل HomepageController
  PageController? pageController;

  //=======================================================cart
  @override
  void onInit() {
    startTimer();
    pageController = PageController(
      initialPage: 0,
      viewportFraction:
          0.5, // مهم جداً: هذا الرقم هو ما يظهر جزءاً من الكروت الجانبية
    );
    getdata();
    username = myservisec.sharedPreferences.getString("username");
    super.onInit();
  }

  @override
  void onClose() {
    // التعديل: نقوم بحذف الكنترولر ثم جعله null فوراً
    // هذا يضمن أن الواجهة (CurvedItemsView) ستدخل في شرط الحماية if (controller.pageController == null)
    pageController?.dispose();
    pageController = null;
    timer?.cancel();

    super.onClose();
  }
}
