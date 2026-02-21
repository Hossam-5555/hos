import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/Homepage/CurvedItemsView.dart';
import 'package:hos/veiw/wedget/Homepage/categorieswidget.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';
import 'package:hos/veiw/wedget/Homepage/productListcard.dart';
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
                              ///  Categories Title
                              const Titles(title: "Categories"),
                              SizedBox(height: height * 0.015),

                              ///  Categories List
                              SizedBox(
                                height: height * 0.12,
                                child: const listcatigories(),
                              ),

                              SizedBox(height: height * 0.02),

                              ///  Main Offer
                              AutoRotatingOffers(),

                              SizedBox(height: height * 0.02),

                              ///  Indicator
                              SizedBox(height: height * 0.02),

                              ///  Curved Items
                              const CurvedItemsView(),

                              SizedBox(height: height * 0.025),

                              ///  New Offers Header
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
                                      foregroundColor: Appcolor.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 700,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.items.length,
                                  itemBuilder: (context, index) {
                                    final p = controller.items[index];

                                    return ProductListCard(
                                      image: "${LinkApi.imageitems}/${p.itemsImage}",
                                      title: p.itemsName.toString(),
                                      price: p.itemsPrice.toString(),
                                      // oldPrice: p.Itmeol.toString(),
                                      rating: 3,
                                      onTap: () {},
                                    );
                                  },
                                ),
                              ),

                              SizedBox(height: height * 0.015),
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
