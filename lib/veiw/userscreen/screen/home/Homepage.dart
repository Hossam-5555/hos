import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/Homepage/CurvedItemsView.dart';
import 'package:hos/veiw/wedget/Homepage/categorieswidget.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';

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

                        /// 🔥 Products List (FIXED)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                            // يفضل تحط padding أفقي بسيط هنا لو مش حاطه في الـ parent
                            // horizontal: 16,
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing:
                                16, // زودنا دي شوية عشان الكروت متلزقش في بعض من فوق وتحت
                            childAspectRatio:
                                0.68, // 👈 التعديل الأهم عشان الكارت ياخد طول مناسب والتفاصيل تظهر براحتها
                          ),
                          itemCount: controller.items.length,
                          itemBuilder: (context, index) {
                            final item = controller.items[index];

                            return SharedProductCard(
                              // أو ProductListCard لو حبيت تحتفظ بنفس الاسم
                              image: "${LinkApi.imageitems}/${item.itemsImage}",
                              title: item.itemsName ?? "بدون اسم",
                              price: "${item.itemsPrice} ", // ضفنا علامة العملة
                              rating:
                                  4.5, // مؤقتاً لحد ما تجيب التقييم من الـ API
                              onTap: () {
                                controller.gotoitemsdatails(item);
                              },

                              // 👈 زرار الأكشن المخصص لصفحة الـ Home (زرار إضافة للسلة)
                              actionButton: InkWell(
                                onTap: () {
                                  // هنا هتحط الفانكشن بتاعة إضافة المنتج للسلة
                                  // controller.addToCart(item.itemsId.toString());
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black, // الستايل الفخم
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    Imageasset
                                        .cart, // اتأكد إن مسار الأيقونة صح
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height * 0.02),

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

                        const CurvedItemsView(),

                        SizedBox(height: height * 0.015), 
                        //  GridView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: height * 0.01,
                        //     // يفضل تحط padding أفقي بسيط هنا لو مش حاطه في الـ parent
                        //     // horizontal: 16,
                        //   ),
                        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2,
                        //     crossAxisSpacing: 12,
                        //     mainAxisSpacing:
                        //         16, // زودنا دي شوية عشان الكروت متلزقش في بعض من فوق وتحت
                        //     childAspectRatio:
                        //         0.68, // 👈 التعديل الأهم عشان الكارت ياخد طول مناسب والتفاصيل تظهر براحتها
                        //   ),
                        //   itemCount: controller.items.length,
                        //   itemBuilder: (context, index) {
                        //     final item = controller.items[index];

                        //     return SharedProductCard(
                        //       // أو ProductListCard لو حبيت تحتفظ بنفس الاسم
                        //       image: "${LinkApi.imageitems}/${item.itemsImage}",
                        //       title: item.itemsName ?? "بدون اسم",
                        //       price: "${item.itemsPrice} ", // ضفنا علامة العملة
                        //       rating:
                        //           4.5, // مؤقتاً لحد ما تجيب التقييم من الـ API
                        //       onTap: () {
                        //         controller.gotoitemsdatails(item);
                        //       },

                        //       // 👈 زرار الأكشن المخصص لصفحة الـ Home (زرار إضافة للسلة)
                        //       actionButton: InkWell(
                        //         onTap: () {
                        //           // هنا هتحط الفانكشن بتاعة إضافة المنتج للسلة
                        //           // controller.addToCart(item.itemsId.toString());
                        //         },
                        //         borderRadius: BorderRadius.circular(50),
                        //         child: Container(
                        //           height: 32,
                        //           width: 32,
                        //           padding: const EdgeInsets.all(6),
                        //           decoration: const BoxDecoration(
                        //             color: Colors.black, // الستايل الفخم
                        //             shape: BoxShape.circle,
                        //           ),
                        //           child: SvgPicture.asset(
                        //             Imageasset
                        //                 .cart, // اتأكد إن مسار الأيقونة صح
                        //             colorFilter: const ColorFilter.mode(
                        //               Colors.white,
                        //               BlendMode.srcIn,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ), jq15
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
