import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/favorite/myfavcontroler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/screen/searchpage.dart';
import 'package:hos/veiw/wedget/myfavcard.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class Myfavorite extends StatelessWidget {
  const Myfavorite({super.key});

  @override
  Widget build(BuildContext context) {
    Myfavcontroler controller = Get.put(Myfavcontroler());
    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضله"),
        leading: Padding(
          // الخطوة 1: إضافة هامش قياسي ليكون بعيدًا عن الحافة
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
            height: 48,
            padding: EdgeInsets.only(left: 4),

            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                // إضافة ظل خفيف ليعطي عمقاً
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 24, // الخطوة 4: تحديد حجم قياسي للأيقونة
              splashRadius: 24, // لجعل تأثير الضغط لا يخرج عن الدائرة
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Searchbar(
                onPressedIcon: () {
                  controller.onsearch();
                },
                onChanged: (val) {
                  controller.checksearch(val);
                },
                title: "ابحث عن منتج...",
                mycontroller: controller.search!,
              ),
            ),
            Expanded(
              // ✅ أضفت Expanded هنا
              child: GetBuilder<Myfavcontroler>(
                builder: (controller) => Handlingdataview(
                  statusrequest: controller.statusrequest,
                  widget: !controller.issearch
                      ? GridView.builder(
                          shrinkWrap: true, // ✅ يمنع التضارب مع Expanded
                          physics:
                              const BouncingScrollPhysics(), // ✅ للسكرول الطبيعي
                          itemCount: controller.data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (context, i) =>
                              favcard(items: controller.data[i]),
                        )
                      : Searchpage(searchdata: controller.searchlist),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
