import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homepage_controller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/screen/searchpage.dart';
import 'package:hos/veiw/wedget/Homepage/CurvedItemsView.dart';
import 'package:hos/veiw/wedget/Homepage/categorieswidget.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomepageController());

    return GetBuilder<HomepageController>(
      builder: (controller) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 🔍 شريط البحث
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

              // ✅ المحتوى القابل للتمدد داخل Column
              Handlingdataview(
                statusrequest: controller.statusrequest,
                widget: !controller.issearch
                    ? Container(height: 680,
                      child: ListView(
                          children: [
                            Titles(title: "Catigories"),
                            SizedBox(height: 38, child: listcatigories()),
                                    
                            OfferCard(
                              title: 'خصم على الأجهزة',
                              description:
                                  "خصم يصل إلى 50% على الهواتف واللابتوبات",
                              discount: "50% OFF",
                              onTap: () {},
                            ),
                                    
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Titles(title: "Most Recent"),
                                TextButton.icon(
                                  icon: Text("view more"),
                                  onPressed: () {},
                                  label: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.cyanAccent,
                                  ),
                                ),
                              ],
                            ),
                                    
                            CurvedItemsView(),
                                    
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Titles(title: "last seen"),
                                TextButton.icon(
                                  icon: Text("See All"),
                                  onPressed: () {},
                                  label: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.cyanAccent,
                                  ),
                                ),
                              ],
                            ),
                                    
                            // SizedBox(
                            //   height: 250,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: 4,
                            //     itemBuilder: (context, i) {
                            //       return Container(
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(20),
                            //         ),
                            //         width: 150,
                            //         margin:
                            //             EdgeInsets.symmetric(horizontal: 8),
                            //         child: ItemsCardhome(index: i),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                    )
                    : Searchpage(searchdata: controller.searchlist),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

