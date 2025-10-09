import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/addresdata.dart';
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

  int? Paymentmethod;
  String? deleverytype;
  int? Addressid;

  choospaymentmethod(val) {
    Paymentmethod = val;
    update();
  }

  choosedeleverytype(val) {
    deleverytype = val;
    update();
  }

  chooseAddres(val) {
    Addressid = val;
    update();
  }

  Addresdata addresdata = Addresdata(Get.find());
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
                       print("sdadawdwadaw${ListAddresdata[0].addresName}");

        if (ListAddresdata.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    getaddress();
    super.onInit();
  }
}
