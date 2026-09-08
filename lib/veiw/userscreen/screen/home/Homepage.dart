import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';
import 'package:hos/veiw/wedget/Homepage/Ads.dart';
import 'package:hos/veiw/wedget/Homepage/CurvedItemsView.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:hos/veiw/wedget/bulidfooter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomepageController controller = Get.find<HomepageController>();
    final bool showSkeleton = controller.statusrequest == Statusrequest.loading;
    return GetBuilder<HomepageController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true, // مهم مع الكيبورد
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => controller.getdata(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                // نقاط توقف بسيطة: هاتف صغير / هاتف عادي / تابلت
                final bool isSmallPhone = width < 360;
                final bool isTablet = width >= 600;

                // مسافات متجاوبة اعتماداً على العرض (أثبت من الطول بين الأجهزة)
                // مع حدود دنيا وقصوى عشان ماتبقاش صغيرة أوي أو كبيرة أوي
                final double horizontalPadding = (width * 0.045).clamp(
                  12.0,
                  32.0,
                );
                final double sectionSpacing = (width * 0.05).clamp(14.0, 26.0);

                // ارتفاع قائمة التصنيفات الأفقية: نسبة من العرض مش من الطول
                final double categoryHeight = (width * 0.32).clamp(92.0, 132.0);

                // عدد أعمدة الجريد: 2 للهاتف، 3 للتابلت الصغير، 4 للتابلت الكبير
                final int gridCrossAxisCount = isTablet
                    ? (width >= 900 ? 4 : 3)
                    : 2;
                final double gridSpacing = isSmallPhone ? 10.0 : 12.0;

                // عرض الكارت الفعلي بعد خصم الـ padding والمسافات بين الأعمدة
                final double cardWidth =
                    (width -
                        (horizontalPadding * 2) -
                        (gridSpacing * (gridCrossAxisCount - 1))) /
                    gridCrossAxisCount;
                final itemWidth = (width - 30) / 3;

                return HandlingDataView(
                  mode: HandlingMode.fullScreen,
                  showRetryButton: true,
                  onRetry: () {
                    controller.getdata();
                  },
                  statusrequest:
                      controller.statusrequest == Statusrequest.loading
                      ? Statusrequest.none
                      : controller.statusrequest,
                  widget: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: sectionSpacing * 0.1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Main Offer
                          Skeletonizer(
                            enabled: showSkeleton,
                            child: AutoRotatingOffers(),
                          ),

                          SizedBox(height: sectionSpacing),
                          Skeletonizer(
                            enabled: showSkeleton,
                            child: Titles(title: "Categories".tr),
                          ),
                          SizedBox(height: sectionSpacing * 0.6),

                          SizedBox(
                            height: (categoryHeight * 2),
                            child: HandlingDataView(
                              statusrequest: controller.statusrequest,
                              mode: HandlingMode.skeleton,
                              widget: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // صفين
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio:
                                          categoryHeight / itemWidth,
                                    ),
                                itemCount: controller.categories.length,
                                itemBuilder: (context, index) {
                                  final cat = controller.categories[index];

                                  return CategoryCard.Homepage(
                                    inHome: true,
                                    onTap: () {
                                      controller.gotoitems(
                                        controller.categories,
                                        index,
                                        controller.categories[index].id
                                            .toString(),
                                      );
                                    },
                                    name: controller.isarabic
                                        ? cat.nameAr
                                        : cat.name,
                                    onEdit: () {},
                                    onDelete: () {},
                                    imageUrl: cat.image!,
                                  );
                                },
                              ),
                            ),
                          ),

                          /// New Items Header
                          Skeletonizer(
                            enabled: showSkeleton,
                            child: Titles(title: "New Items".tr),
                          ),
                          CurvedItemsView(),

                          SizedBox(height: sectionSpacing),

                          // ─── إعلانات ───
                          Skeletonizer(
                            enabled: showSkeleton,
                            child: Titles(title: "Special Offers".tr),
                          ),
                          SizedBox(height: sectionSpacing * 0.6),
                          Skeletonizer(
                            enabled: showSkeleton,
                            child: AdsSection(),
                          ), // ← ضيف ده هنا[]

                          SizedBox(height: sectionSpacing * 0.5),
                          Skeletonizer(
                            enabled: showSkeleton,
                            child: Titles(title: "Most Sale".tr),
                          ),
                          SizedBox(height: sectionSpacing * 0.6),

                          Skeletonizer(
                            enabled: showSkeleton,
                            child: MasonryGridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                vertical: sectionSpacing * 0.3,
                              ),
                              gridDelegate:
                                  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: gridCrossAxisCount,
                                  ),
                              mainAxisSpacing: gridSpacing + 4,
                              crossAxisSpacing: gridSpacing,
                              itemCount: controller.mostsaleitem.length,
                              itemBuilder: (context, index) {
                                final item = controller.mostsaleitem[index];

                                // ارتفاع الكارت نسبي لعرضه الفعلي، مش رقم ثابت،
                                // فبكده بيتصرف صح على أي مقاس شاشة
                                final double baseHeight = cardWidth * 1.55;
                                final double cardHeight = index.isEven
                                    ? baseHeight
                                    : baseHeight * 1.2;

                                return SharedProductCard(
                                  image: "${item.itemsImage}",
                                  title: "${item.itemsName}",
                                  price: "${item.itemsPrice}",
                                  rating: 4.8,
                                  onTap: () {
                                    controller.gotoitemsdetails(item);
                                  },

                                  actionButton: AddToCartButton(
                                    itemId: item.id!,
                                  ),

                                  /// 🔥 أهم سطر
                                  height: cardHeight,
                                );
                              },
                            ),
                          ),

                          //footer
                          SizedBox(height: sectionSpacing * 0.6),
                          Center(child: buildFooter()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
          Get.find<CartController>().addtocart(itemId, 1);

          // 2️⃣ تغيير اللون لعلامة صح
          added.value = true;

          // 3️⃣ بعد ثانية يرجع للوضع الطبيعي
          Future.delayed(const Duration(seconds: 1), () {
            added.value = false;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: added.value ? Colors.green : Colors.black,
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            switchInCurve: Curves.bounceIn,
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
