import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
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
  List<ItemsModel> mostsaleitem = [];
  List<ItemsModel> newArival = [];
  List<CategoriesModel> categories = [];
  Statusrequest statusrequest = Statusrequest.none;
  bool get isarabic => myservisec.sharedPreferences.getString("lang") == "ar";

  Homedata homedata = Homedata(Get.find());

  Future<void> getdata() async {
    statusrequest = Statusrequest.loading;
    update();

    try {
      var response = await homedata.postdata();

      statusrequest = handling(response);

      if (Statusrequest.success == statusrequest) {
        if (response["status"] == true) {
          // 1. مسح البيانات القديمة قبل إضافة الجديدة لتجنب التكرار
          categories.clear();
          mostsaleitem.clear();
          newArival.clear();

          // 2. الوصول للبيانات داخل "data" مباشرة
          var data = response["data"];

          // 3. تحويل البيانات بأسلوب مختصر ونظيف
          categories.addAll(
            List<CategoriesModel>.from(
              data["categories"].map((e) => CategoriesModel.fromJson(e)),
            ),
          );

          mostsaleitem.addAll(
            List<ItemsModel>.from(
              data["best_sellers"].map((e) => ItemsModel.fromJson(e)),
            ),
          );

          newArival.addAll(
            List<ItemsModel>.from(
              data["new_arrivals"].map((e) => ItemsModel.fromJson(e)),
            ),
          );
          statusrequest = Statusrequest.success;
        } else {
          statusrequest = Statusrequest.failure;
        }
      }
    } catch (e) {
      statusrequest = Statusrequest.serverfailure;
    }

    update();
  }

  void gotoitems(List categories, int selecteditem, String catid) {
    Get.toNamed(
      Approute.Items,
      arguments: {
        'categories': categories,
        'selecteditem': selecteditem,
        "catid": catid,
      },
    );
    update();
  }

  /// يفتح صفحة "Items" وتعرض كل عناصر قسم معيّن (مثلاً "New Items" أو "Most Sale")
  /// لما يضغط المستخدم على زرار "See All"
  void gotoAllItems(List<ItemsModel> items, String sectionTitle) {
    Get.to(
      () => Items(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 400),
      arguments: {'items': items, 'title': sectionTitle},
    );
  }

  void gotoitemsdetails(ItemsModel itemsmodel) {
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
      image:
          "https://images.unsplash.com/photo-1616348436168-de43ad0db179?q=80&w=1000&auto=format&fit=crop", // صورة iPhone/Smartphone
      title: 'أحدث إصدارات الهواتف',
      description: 'اكتشف قوة الأداء مع كاميرا فائقة الدقة ومعالج هو الأسرع.',
      discount: 'خصم 15%',
      colors: const [
        Color(0xFF000000), // أسود ملكي
        Color(0xFF1A1A1B), // رمادي داكن جداً
      ],
    ),

    OfferModel(
      image:
          "https://images.unsplash.com/photo-1593642702821-c8da6771f0c6?q=80&w=1000&auto=format&fit=crop", // صورة Laptop احترافي
      title: 'أجهزة الـ Laptop الاحترافية',
      description: 'ارفع مستوى إنتاجيتك مع أجهزة مخصصة للمبرمجين والمصممين.',
      discount: 'وفر حتى 500 ريال',
      colors: const [
        Color(0xFF0F2027), // أزرق ليلي داكن
        Color(0xFF203A43),
      ],
    ),

    OfferModel(
      image:
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1000&auto=format&fit=crop", // صورة سماعات Headphones
      title: 'عالم الصوتيات الذكي',
      description: 'تجربة صوتية محيطية مع تقنية عزل الضجيج النشطة.',
      discount: 'لفترة محدودة',
      colors: const [
        Color(0xFF141E30), // مزيج بين الكحلي والأسود
        Color(0xFF243B55),
      ],
    ),
  ];
  int i = 0; // متغير لتغيير cross Axis gridview  العرض الحالي
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
