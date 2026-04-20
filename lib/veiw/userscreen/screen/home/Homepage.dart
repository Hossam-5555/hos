import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/Homepage/CurvedItemsView.dart';
import 'package:hos/veiw/wedget/Homepage/categorieswidget.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Categories Title

                        /// Main Offer
                        AutoRotatingOffers(),

                        SizedBox(height: height * 0.02),
                        Titles(title: "Categories".tr),
                        // SizedBox(height: height * 0.012),

                        /// Categories List
                        SizedBox(
                          height: height * 0.16,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              final cat = controller.categories[index];
                              return Skeletonizer(
                                containersColor: Colors.grey[20],
                                enabled:
                                    controller.statusrequest ==
                                    Statusrequest.loading,
                                child: CategoryItem(
                                  index: index,
                                  name: cat.name ?? "",
                                  imageUrl: cat.image.toString(),
                                ),
                              );
                            },
                          ),
                        ),

                        /// Curved Items
                        // const CurvedItemsView(),
                        SizedBox(height: height * 0.025),

                        /// New Offers Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Titles(title: "New Items".tr),
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
                        // const CurvedItemsView(),

                        /// 🔥 Products List (FIXED)
                        ///
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Titles(title: "Most Sale".tr),
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
                        SizedBox(height: height * 0.02),
                        // MasonryGridView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: height * 0.01,
                        //   ),
                        //   gridDelegate:
                        //       const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: 2,
                        //       ),
                        //   mainAxisSpacing: 16,
                        //   crossAxisSpacing: 12,
                        //   itemCount: controller.items.length,
                        //   itemBuilder: (context, index) {
                        //     final item = controller.items[index];

                        //     return SharedProductCard(
                        //       image: "${LinkApi.imageitems}/${item.itemsImage}",
                        //       title: item.itemsName ?? "بدون اسم",
                        //       price: "${item.itemsPrice}",
                        //       rating: 4.8,
                        //       onTap: () {
                        //         controller.gotoitemsdatails(item);
                        //       },

                        //       actionButton: AddToCartButton(
                        //         itemId: item.itemsId.toString(),
                        //       ),

                        //       /// 🔥 أهم سطر
                        //       height: index.isEven
                        //           ? 260
                        //           : 320, // 👈 خلي الكارت يقبل height
                        //     );
                        //   },
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Titles(title: "Most View".tr),
                        //     TextButton.icon(
                        //       onPressed: () {},
                        //       icon: const Text("See All"),
                        //       label: const Icon(
                        //         Icons.arrow_forward_ios,
                        //         size: 16,
                        //       ),
                        //       style: TextButton.styleFrom(
                        //         foregroundColor: Appcolor.primaryColor,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: height * 0.015),
                        // MasonryGridView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: height * 0.01,
                        //   ),
                        //   gridDelegate:
                        //       const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: 2,
                        //       ),
                        //   mainAxisSpacing: 16,
                        //   crossAxisSpacing: 12,
                        //   itemCount: controller.items.length,
                        //   itemBuilder: (context, index) {
                        //     final item = controller.items[index];

                        //     return SharedProductCard(
                        //       image: "${LinkApi.imageitems}/${item.itemsImage}",
                        //       title: item.itemsName ?? "بدون اسم",
                        //       price: "${item.itemsPrice}",
                        //       rating: 4.8,
                        //       onTap: () {
                        //         controller.gotoitemsdatails(item);
                        //       },

                        //       actionButton: AddToCartButton(
                        //         itemId: item.itemsId.toString(),
                        //       ),

                        //       height: index.isEven
                        //           ? 260
                        //           : 320, //  خلي الكارت يقبل height
                        //     );
                        //   },
                        // ),
                      ],
                    ),
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

class AddToCartButton extends StatelessWidget {
  final int itemId;

  AddToCartButton({super.key, required this.itemId});

  // متغير الحالة الخاص بالزر ده فقط
  final RxBool added = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          // 1️⃣ إضافة للـ Cart
          CartController().addtocart(itemId, 1);

          // 2️⃣ تغيير اللون لعلامة صح
          added.value = true;

          // 3️⃣ بعد ثانية يرجع للوضع الطبيعي
          Future.delayed(const Duration(seconds: 1), () {
            added.value = false;
          });
        },
        borderRadius: BorderRadius.circular(50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 32,
          width: 32,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: added.value ? Colors.green : Colors.black,
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: added.value
                ? const Icon(
                    Icons.check,
                    key: ValueKey('check'),
                    color: Colors.white,
                    size: 20,
                  )
                : SvgPicture.asset(
                    Imageasset.cart,
                    key: const ValueKey('cart'),
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
