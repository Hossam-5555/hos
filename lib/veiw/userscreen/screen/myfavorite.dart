import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/myfavcontroler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/myfavcard.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class Myfavorite extends StatelessWidget {
  const Myfavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Myfavcontroler controller = Get.put(Myfavcontroler());
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Center(
            child: Container(
              width: 45, // حجم متناسق أكتر مع الـ AppBar
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                // ضروري جداً داخل Hero عشان الـ Splash يظهر صح
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    // ✅ حماية: اقفل أي رسالة مفتوحة قبل ما ترجع
                    Navigator.of(context).pop();
                    // ✅ رجوع للصفحة السابقة
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  iconSize: 20,
                ),
              ),
            ),
          ),
        ),
        title: Searchbar(
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Padding(
            //   padding: EdgeInsets.all(width * 0.03), // Padding نسبي
            //   child:
            // ),
            Expanded(
              child: GetBuilder<Myfavcontroler>(
                builder: (controller) => Handlingdataview(
                  statusrequest: controller.statusrequest,
                  widget: !controller.issearch
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.data.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.015,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    width / (height * 0.70), // نسبي
                                crossAxisSpacing: width * 0.03,
                                mainAxisSpacing: height * 0.015,
                              ),
                          itemBuilder: (context, i) =>
                              FavCard(items: controller.data[i]),
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
