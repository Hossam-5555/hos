import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/addresdata.dart';
import 'package:hos/data/datasource/remote/checkoutdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class Checkoutcontroller extends GetxController {
  //============================
  final List<Map<String, String>> addresses = [
    {"title": "Home Address", "subtitle": "123 Main St, Cairo"},
    {"title": "Work Address", "subtitle": "Downtown, Nasr City"},
    {"title": "Other Address", "subtitle": "Alexandria, Corniche"},
  ];

  // وسائل دفع افتراضية (Placeholder)
  final List<List> paymentMethods = [
    ["Cash", Imageasset.cash],
    ["Visa", Imageasset.Visa],
    ["Wallet", Imageasset.googlepay],
  ];

  //===============================

  int? Paymenttype;
  String? deleverytype;
  int Addressid = 0;

  void choospaymentmethod(val) {
    Paymenttype = val;
    update();
  }

  void choosedeleverytype(val) {
    // "Delivery" or "Pickup"
    deleverytype = val;
    update();
  }

  void chooseAddres(val) {
    Addressid = val;
    update();
  }

  Addresdata addresdata = Addresdata(Get.find());
  Checkoutdata checkoutdata = Checkoutdata(Get.find());

  Myservisec myservisec = Get.find();
  Statusrequest? statusrequest;
  List<Addresmodel> ListAddresdata = [];
  Future<void> getaddress() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.viewAddresdata(
      myservisec.sharedPreferences.getString("id")!,
    );

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List data = response['data'];

        // تنظيف القائمة قبل الإضافة
        ListAddresdata.addAll(data.map((e) => Addresmodel.fromJson(e)));
        // إذا كانت القائمة غير فارغة، اختر أول عنوان كافتراضي
        if (ListAddresdata.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  Future<void> checkoutoder() async {
    if (Addressid == 0) {
            Get.snackbar("خطأ ", "الرجاء ادخال العنوان ");

    } else if (Paymenttype == null) {
            Get.snackbar("خطأ ", "الرجاء ادخال وسيله دفع");

    } 
    else {
      statusrequest = Statusrequest.loading;
      update();
      Map data = {
        "userid": myservisec.sharedPreferences.getString("id")!,
        "addressid": Addressid.toString(),
        "orderstype": "pickup",
        "pricedelivery": "10",
        "ordersprice": totalprice,
        "couponid": couponeid.toString(),
        "paymentmethod": Paymenttype.toString(),
      };
      var response = await checkoutdata.Checkout(data);

      statusrequest = handling(response);
      if (Statusrequest.success == statusrequest) {
        if (response['status'] == 'success') {
          Get.snackbar(
            "Order",
            "Order placed successfully",
            animationDuration: Duration(milliseconds: 800),
          );
          Get.offAllNamed(Approute.Homescreen);
        } else {
          statusrequest = Statusrequest.none;
          Get.snackbar("خطأ في البيانات ", "الرجاء المحاوله مره اخري");
        }
      }
      update();
    }
  }

  late String couponeid;
  late String totalprice;

  @override
  void onInit() {
    couponeid = Get.arguments['couponeID'].toString();
    totalprice = Get.arguments['totalprice'];
    getaddress();
    super.onInit();
  }
}
