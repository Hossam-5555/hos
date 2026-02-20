import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/Homepage/CurvedItemsView.dart';
import 'package:hos/veiw/wedget/Homepage/categorieswidget.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomepageController());
    final homescreencontroller = Get.put(Homescreencontroller());

    return GetBuilder<HomepageController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return SingleChildScrollView(
                controller: homescreencontroller.scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.015,
                  ),
                  child: Handlingdataview(
                    statusrequest: controller.statusrequest,
                    widget: !controller.issearch
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 🔥 Categories Title
                              const Titles(title: "Categories"),
                              SizedBox(height: height * 0.015),

                              /// 🔥 Categories List
                              SizedBox(
                                height: height * 0.12,
                                child: const listcatigories(),
                              ),

                              SizedBox(height: height * 0.02),

                              /// 🔥 Main Offer
                              OfferCard(
                                title: 'خصم على الأجهزة',
                                description:
                                    "خصم يصل إلى 50% على الهواتف واللابتوبات",
                                discount: "50% OFF",
                                onTap: () {},
                              ),

                              SizedBox(height: height * 0.02),

                              /// 🔥 Indicator
                              GetBuilder<HomepageController>(
                                builder: (controller) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    2,
                                    (index) => AnimatedContainer(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      width: controller.currntofer == index
                                          ? 18
                                          : 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Appcolor.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 300),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.02),

                              /// 🔥 Curved Items
                              const CurvedItemsView(),

                              SizedBox(height: height * 0.025),

                              /// 🔥 New Offers Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Titles(title: "New Offers"),
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: const Text("See All"),
                                    label: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Appcolor.primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: height * 0.015),

                              /// 🔥 Second Offer
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}