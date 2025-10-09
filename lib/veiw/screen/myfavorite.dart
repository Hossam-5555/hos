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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }
}
