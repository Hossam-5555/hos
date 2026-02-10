import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
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
    Homescreencontroller homescreencontroller = Get.put(Homescreencontroller());

    return GetBuilder<HomepageController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            controller: homescreencontroller.scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔍 شريط البحث
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
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
                              Titles(title: "Categories "),
                              SizedBox(height: height * 0.01),

                              /// 🔥 كاتيجوريز
                              SizedBox(
                                height: height * 0.10, // تعديل نسبي
                                child: listcatigories(),
                              ),

                              /// 🔥 كارت الخصم
                              OfferCard(
                                title: 'خصم على الأجهزة',
                                description:
                                    "خصم يصل إلى 50% على الهواتف واللابتوبات",
                                discount: "50% OFF",
                                onTap: () {},
                              ),
                              SizedBox(height: height * 0.010),

                              /// 🔥 الكيرفيد ايتيمز
                              CurvedItemsView(),
                              SizedBox(height: height * 0.015),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Titles(title: " New Collections"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextButton.icon(
                                      iconAlignment: IconAlignment.start,
                                      onPressed: () {},
                                      icon: const Text(
                                        " See All",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            109,
                                            109,
                                            109,
                                          ),
                                        ),
                                      ),
                                      label: const Icon(
                                        Icons.arrow_forward,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              OfferCard(
                                title: 'خصم على الأجهزة',
                                description:
                                    "خصم يصل إلى 50% على الهواتف واللابتوبات",
                                discount: "50% OFF",
                                onTap: () {},
                              ),
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
