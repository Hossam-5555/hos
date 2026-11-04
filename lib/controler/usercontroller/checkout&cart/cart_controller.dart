import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/cartdata.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/checkout.dart';

class CartController extends GetxController {
  // الاعتمادات والخدمات
  Cartdata cartdata = Cartdata(Get.find());
  Statusrequest statusrequest = Statusrequest.none; // يفضل أن تبدأ بـ none
  Myservisec myservisec = Get.put(Myservisec());
  CartModel cart = CartModel();

  int? get userid => myservisec.sharedPreferences.getInt("id");
  bool isCartLoaded = false; // 🌟 علم لمعرفة هل تم تحميل السلة مسبقاً أم لا
  final scrol = ScrollController();
  // الأنيميشن
  late AnimationController controllerAnimation;
  late Animation<double> priceAnimation;

  // الكوبون


  // بيانات السلة
  List<CartModel> data = [];
  RxInt get countitem => data.length.obs;
  int totalcount = 0;
  double totalprice = 0.0;

 


  // void havecoupone(bool value) async {
  //   coupone.value = value;
  //   final prefs = myservisec.sharedPreferences;
  //   await prefs.setBool('cop', value);
  // }

  /// ================== دالة عرض السلة (مع تحديث صامت) ==================
  // 🌟 أضفنا showLoading عشان نقدر نحدث البيانات في الخلفية بدون ما نوقف الشاشة
  Future<void> view({bool showLoading = true}) async {
    // نعرض اللودينج فقط لو دي أول مرة نفتح فيها السلة
    if (showLoading && !isCartLoaded) {
      statusrequest = Statusrequest.loading;
      update();
    }

    var response = await cartdata.viewcart();
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response["status"] == true) {
        data.clear();
        List datarespons = response["data"]["cart"];
        data.addAll(datarespons.map((e) => CartModel.fromJson(e)));

        totalcount =
            int.tryParse(response["data"]["total_count"]?.toString() ?? "0") ??
            0;
        totalprice =
            double.tryParse(
              response["data"]["total_price"]?.toString() ?? "0",
            ) ??
            0.0;

        isCartLoaded = true; // ✅ تم التحميل بنجاح

        if (data.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  /// ================== دالة الإضافة للسلة (Optimistic Update) ==================
  Future<void> addtocart(int itemid, int count) async {
    // 1. أخذ نسخة احتياطية من البيانات الحالية للـ Rollback في حال الفشل
    int oldTotalCount = totalcount;
    double oldTotalPrice = totalprice;
    var oldData = List<CartModel>.from(data);

    // 2. تحديث الـ UI محلياً فوراً (بدون loading)
    totalcount += count;

    // لو بنضيف المنتج من داخل صفحة السلة، نحدث الكمية بتاعته محلياً
    var index = data.indexWhere((e) => e.itemid == itemid);
    if (index != -1) {
      data[index].cartCount = (data[index].cartCount ?? 0) + count;
      // حساب السعر محلياً (تأكد أن حقل itemsPrice موجود بالاسم الصحيح في المودل)
      double itemPrice =
          double.tryParse(data[index].itemsprice?.toString() ?? "0") ?? 0.0;
      totalprice += (itemPrice * count);
    }
    update(); // التحديث اللحظي للواجهة 🚀

    // 3. إرسال الطلب للسيرفر في الخلفية
    var response = await cartdata.addcartdata(itemid, count);
    var requestStatus = handling(response);

    if (requestStatus == Statusrequest.success && response["status"] == true) {
      // 4. السيرفر نجح: نعمل مزامنة صامتة عشان نتأكد إن كل الداتا دقيقة 100%
      await view(showLoading: false);
      if (Get.isRegistered<Itemdetailscontroller>()) {
        showSnackBar(
          Get.context!,
          "Add Item to cart",
          Icon(Icons.check_circle_outlined, color: Colors.green),
        );
      }
    } else {
      // 5. في حال الفشل: تراجع عن التحديثات (Rollback) ونبه المستخدم
      totalcount = oldTotalCount;
      totalprice = oldTotalPrice;
      data = oldData;
      update();

      String errorMsg = response["message"] ?? "حدث خطأ في الاتصال بالسيرفر";
      showSnackBar(
        Get.context!,
        errorMsg,
        const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }

  /// ================== زيادة العدد ==================
  void increment(int itemId) async {
    await addtocart(itemId, 1);
  }

  /// ================== نقصان العدد / حذف منتج ==================
  void decrement(int itemid) async {
    var index = data.indexWhere((e) => e.itemid == itemid);
    if (index == -1) return;

    int currentCount = data[index].cartCount ?? 0;

    // إذا كانت الكمية الحالية 1 والمستخدم ضغط ناقص (يعني هيحذف)
    if (currentCount >= 1) {
      await delete(itemid);
    }
  }

  Future<void> delete(int itemid) async {
    // 1. تجهيز الـ Rollback
    int oldTotalCount = totalcount;
    double oldTotalPrice = totalprice;
    var oldData = List<CartModel>.from(data);

    var index = data.indexWhere((e) => e.itemid == itemid);
    if (index == -1) return;

    int currentCount = data[index].cartCount ?? 0;
    double itemPrice =
        double.tryParse(data[index].itemsprice?.toString() ?? "0") ?? 0.0;

    // 2. تحديث الـ UI محلياً فوراً
    totalcount -= 1;
    totalprice -= itemPrice;

    if (currentCount <= 1) {
      data.removeAt(index); // إزالة العنصر تماماً من السلة لو كان آخر حبة
      if (data.isEmpty) statusrequest = Statusrequest.failure;
    } else {
      data[index].cartCount = currentCount - 1; // تنقيص حبة واحدة
    }
    update(); // التحديث اللحظي 🚀

    // 3. إرسال طلب الحذف للسيرفر
    var response = await cartdata.deletcartdata(itemid);
    var requestStatus = handling(response);

    if (requestStatus == Statusrequest.success && response["status"] == true) {
      // 4. مزامنة صامتة بعد النجاح
      await view(showLoading: false);
    } else {
      // 5. التراجع (Rollback) في حال الفشل
      totalcount = oldTotalCount;
      totalprice = oldTotalPrice;
      data = oldData;
      if (data.isNotEmpty) statusrequest = Statusrequest.success;
      update();

      showSnackBar(
        Get.context!,
        "فشل تنفيذ العملية",
        const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }

  /// ================== الانتقال للدفع ==================
  void gotochechout() {
    Get.to(
      () => const Checkout(),
      transition: Transition.fadeIn,
      arguments: {
        "Cartdata": data,
        "totalprice":totalprice,
      },
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void onInit() {

    // نستدعي البيانات أول مرة يفتح فيها التطبيق
    view();
    super.onInit();
  }


}
