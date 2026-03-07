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
    final HomepageController controller = Get.put(HomepageController());
    final Homescreencontroller homescreencontroller = Get.put(
      Homescreencontroller(),
    );

    return GetBuilder<HomepageController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true, // مهم مع الكيبورد
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return SingleChildScrollView(
                controller: homescreencontroller.scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                              /// Categories Title
                              Titles(title: "3".tr),
                              // SizedBox(height: height * 0.012),

                              /// Categories List
                              SizedBox(
                                height: height * 0.16,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.categories.length,
                                  itemBuilder: (context, index) {
                                    final cat = controller.categories[index];
                                    return CategoryItem(
                                      index: index,
                                      name: cat.categoriesName ?? "",
                                      imageUrl:
                                          "${LinkApi.imagecategories}/${cat.categoriesImage}",
                                    );
                                  },
                                ),
                              ),

                              /// Main Offer
                              AutoRotatingOffers(),

                              SizedBox(height: height * 0.02),

                              /// Curved Items
                              const CurvedItemsView(),

                              SizedBox(height: height * 0.025),

                              /// New Offers Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Titles(title: "4".tr),
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

                              /// 🔥 Products List (FIXED)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.80,
                                    ),
                                itemCount: controller.items.length,
                                itemBuilder: (context, index) {
                                  final item = controller.items[index];

                                  return ProductListCard(
                                    image:
                                        "${LinkApi.imageitems}/${item.itemsImage}",
                                    title: item.itemsName ?? "",
                                    price: item.itemsPrice.toString(),
                                    rating: 4,
                                  );
                                },
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
