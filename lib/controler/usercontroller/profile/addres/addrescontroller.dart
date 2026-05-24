import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class AddressController extends GetxController {
  Addresdata addresdata = Addresdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest? statusrequest;
  List<AddresModel> listaddresdata = <AddresModel>[].obs;
  GlobalKey<FormState> addadredKey = GlobalKey();
  int get userid => myservisec.sharedPreferences.getInt("id")!;
  // متغيرات الحقول
  TextEditingController? name;
  TextEditingController? city;
  TextEditingController? street;
  double lat = 23.3344;
  double long = 23.3344;

  /////////////////////////

  Completer<GoogleMapController>? completercontroller;

  List<Marker> markers = [];

  void addMarkers(LatLng latLng) {
    markers.clear();
    markers.add(Marker(markerId: MarkerId("1"), position: latLng));
    lat = latLng.latitude;
    long = latLng.longitude;
    update();
  }

  @override
  void onInit() {
    name = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    viewaddres();
    super.onInit();
  }

  /////////////////////

  Future<void> addaddres() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.AddAddresdata(
      userid,
      name!.text,
      city!.text,
      street!.text,
      lat.toString(),
      long.toString(),
      "+201034567820",
    );

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        // تحديث القائمة بعد الإضافة
        await viewaddres();
        if (Get.isRegistered<Checkoutcontroller>()) {
          Checkoutcontroller controller = Get.find<Checkoutcontroller>();
          await controller.getaddress();
        }
        Get.back();
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  // viewaddress
  Future<void> viewaddres() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.viewAddresdata(userid);

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response['data'];
        // تنظيف القائمة قبل الإضافة
        listaddresdata.clear();

        listaddresdata.addAll(data.map((e) => AddresModel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  final GlobalKey<AnimatedListState> Addressket =
      GlobalKey<AnimatedListState>();

  void deleteAddres(int addresid) {
    // 1️⃣ البحث عن الـ index الخاص بالعنوان داخل القائمة المحلية قبل حذفه
    int index = listaddresdata.indexWhere((e) => e.id == addresid);
    // 💡 ملاحظة: تأكد هل اسم المتغير في الموديل addressId أم id .. قمت بكتابتها تبعاً لمنطق الكود لديك

    // 2️⃣ التأكد من أن العنصر موجود فعلياً في القائمة لتفادي الـ Crash
    if (index != -1) {
      // أخذ نسخة من العنصر لعرض بياناته أثناء حركية الحذف قبل مسحه من القائمة
      var removedItem = listaddresdata[index];

      // 3️⃣ تحديث الـ AnimatedListState بشكل آمن
      if (Addressket.currentState != null) {
        Addressket.currentState!.removeItem(
          index, // تم التعديل هنا ليأخذ الـ index وليس الـ id
          (context, animation) => ScaleTransition(
            scale: animation,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 0, // إلغاء الظل الثقيل لجعلها عصرية ومسطحة Flat
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // زوايا دائرية ناعمة
                side: BorderSide(
                  color: Colors
                      .red
                      .shade200, // إطار خارجي خفيف جداً بلون أحمر هادئ
                  width: 1,
                ),
              ),
              color: Colors
                  .red
                  .shade50, // خلفية حمراء باهتة ومريحة جداً للعين (Soft Red)
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  // شريط أحمر رأسي جهة اليمين/اليسار يعطي لمسة جمالية واحترافية
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.red.shade600,
                        width: 5,
                      ), // إذا كان التطبيق عربي
                      // left: BorderSide(color: Colors.red.shade600, width: 5), // غيرها لـ left لو واجهة التطبيق إنجليزي
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape
                            .circle, // وضع الأيقونة داخل دائرة خلفيتها حمراء فاتحة
                      ),
                      child: Icon(
                        Icons
                            .delete_sweep_rounded, // أيقونة حذف أكثر احترافية وديناميكية
                        color: Colors.red.shade700,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "تم حذف ${removedItem.name ?? 'العنوان'}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors
                            .red
                            .shade900, // لون الخط متناسق مع الخلفية الحمراء
                        fontFamily:
                            "sans-serif", // استبدله بخط تطبيقك إذا كان لديك خط مخصص
                      ),
                    ),
                    subtitle: const Text(
                      "تم نقل العنصر للمهملات بنجاح",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
              ),
            ),
          ),
          duration: const Duration(milliseconds:500),
        );
      }

      // 4️⃣ حذف العنصر من القائمة المحلية (List) بعد تمرير الـ index للأنيميشن
      listaddresdata.removeAt(index);

      // 5️⃣ استدعاء الـ API لحذف العنوان من السيرفر
      addresdata.deleteAddresdata(addresid, userid);

      // 7️⃣ تحديث حالة الواجهة إذا أصبحت القائمة فارغة
      if (listaddresdata.isEmpty) {
        statusrequest = Statusrequest.failure;
      }

      // 8️⃣ تحديث الواجهة (GetX Update)
      update();
    } else {
      print("خطأ: العنصر غير موجود في القائمة المحلية أساساً!");
    }
  }

  // دالة الحفظ
  List<Marker> marker = [];
  void addmarker(LatLng latlang) {
    marker.clear();
    marker.add(Marker(markerId: MarkerId('1'), position: latlang));
    update();
  }

  @override
  void dispose() {
    name!.dispose();
    city!.dispose();
    street!.dispose();

    super.dispose();
  }
}
