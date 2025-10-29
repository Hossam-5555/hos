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
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Get.put(HomepageController());

    return GetBuilder<HomepageController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔍 شريط البحث
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Searchbar(
                      onPressedIcon: controller.onsearch,
                      onChanged: controller.checksearch,
                      title: "ابحث عن منتج...",
                      mycontroller: controller.search!,
                    ),
                  ),

                  /// ✅ عرض البيانات أو نتيجة البحث
                  Handlingdataview(
                    statusrequest: controller.statusrequest,
                    widget: !controller.issearch
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Titles(title: "Categories"),
                              SizedBox(
                                height: height * 0.080,
                                child: listcatigories(),
                              ),

                              // SizedBox(height: height * 0.02),
                              OfferCard(
                                title: 'خصم على الأجهزة',
                                description:
                                    "خصم يصل إلى 50% على الهواتف واللابتوبات",
                                discount: "50% OFF",
                                onTap: () {},
                              ),

                              CurvedItemsView(),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Titles(title: "شوهد مؤخراً"),
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: const Text(
                                      "عرض الكل",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 109, 109, 109),
                                        fontSize: 14,
                                      ),
                                    ),
                                    label: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.cyanAccent,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            

                              SizedBox(height: height * 0.02),
                              // هنا تقدر تضيف مثلاً آخر المنتجات أو الكروت
                              // ItemsCardhome(index: i)
                            ],
                          )
                        : Searchpage(searchdata: controller.searchlist),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
