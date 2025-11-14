import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/myfavcontroler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.085), // ارتفاع نسبي
        child: Appbarbackicon(herotag: '', title: "My Favorite"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.03), // Padding نسبي
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
                            childAspectRatio: width / (height * 0.60), // نسبي
                            crossAxisSpacing: width * 0.03,
                            mainAxisSpacing: height * 0.015,
                          ),
                          itemBuilder: (context, i) => favcard(
                            items: controller.data[i],
                          ),
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
