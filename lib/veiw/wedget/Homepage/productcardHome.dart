import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/linkApi.dart'; // افترض أن 'linkImageRoot' موجود هنا
import 'package:hos/data/model/itemsmodel.dart';

// 🔹 هذا الكلاس يبقى كما هو
class ItemsCardhome extends GetView<HomepageController> {
  final int index;
  const ItemsCardhome({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    if (controller.items.isEmpty || controller.items[index] == null) {
      return const SizedBox();
    }
    return ItemList(items: Itemsmodel.fromJson(controller.items[index]));
  }
}

// --- ⭐️ الكلاس المُعدل ⭐️ ---

class ItemList extends GetView<HomepageController> {
  final Itemsmodel items;
  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return InkWell(
      onTap: () => controller.gotoitemsdatails(items),
      // ❌ تم حذف ClipPath لاستخدام الزوايا الدائرية من BoxDecoration
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.white, // ✅ تم التغيير إلى الأبيض
          boxShadow: [
            // ✅ تم إضافة ظل خفيف مثل الصورة
            
            BoxShadow(
              color: Colors.black.withAlpha(25), // 0.1 * 255 = 25
              // spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🖼 الصورة
            Container(
              height: height * 0.17,
              // المارجن الخاص بك جيد لعمل الهامش الداخلي
              margin: EdgeInsets.only(left: 17, right: 17, top: 17),
              decoration: BoxDecoration(
                color:  Color.fromARGB(
                      255,
                      146,
                      146,
                      146,
                    ).withAlpha(35), // ✅ لون رمادي فاتح لخلفية الصورة
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ), // ✅ زوايا دائرية لحامل الصورة
              ),
              // ✅ نستخدم ClipRRect لقص زوايا الصورة
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  // ✅ إصلاح: بناء رابط الصورة الصحيح
                  // (بافتراض أن المتغير اسمه linkImageRoot في ملف linkApi.dart)
                  "${LinkApi.imageitems}/${items.itemsImage}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height * 0.20,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 الاسم والسعر وزر السلة
            // هذا الجزء كان منظماً بشكل جيد
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.040, // تعديل بسيط للهوامش
                  vertical: height * 0.012,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      items.itemsName ?? "بدون اسم",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.038,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${items.itemsPrice ?? "0"} ج.م", // تم الإبقاء على العملة الخاصة بك
                          style: TextStyle(
                            fontSize: width * 0.042,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          height: height * 0.05,
                          width: height * 0.05,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            Imageasset.cart,
                            height: 20,
                            width: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ❌ لا حاجة لهذا الكلاس بعد الآن
// class SlightTrapezoidClipper extends CustomClipper<Path> { ... }
