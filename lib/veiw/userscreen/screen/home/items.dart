import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';

import 'package:hos/veiw/wedget/items/productcard.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // مقاسات الشاشة
    final height = size.height;
    final width = size.width;

    ItemsControler controller = Get.put(ItemsControler());
    FavController favController = Get.put(FavController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // اختياري لشكل أنظف
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: SizedBox(
                width: width * 0.65,
                child: Searchbar(
                  onPressedIcon: controller.onsearch,
                  onChanged: controller.checksearch,
                  title: " ابحث عن منتج...",
                  mycontroller: controller.search!,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.grey[200],
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => Container(
                      padding: const EdgeInsets.all(16),
                      height: Get.height * 0.6,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 5,
                                left: 10,
                                right: 5,
                              ),
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      221,
                                      7,
                                      140,
                                      173,
                                    ).withAlpha(140),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Titles(title: "Sort by"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.minimize_outlined,
                                      color: const Color.fromARGB(
                                        221,
                                        7,
                                        140,
                                        173,
                                      ).withAlpha(140),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.filterdata.length,
                              itemBuilder: (_, index) {
                                return filtercard(
                                  "${controller.filterdata[index]}",
                                );
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    return Titles(
                                      title:
                                          "Price : ${controller.price.value}\$",
                                    );
                                  }),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.minimize_outlined,
                                      color: const Color.fromARGB(
                                        221,
                                        7,
                                        140,
                                        173,
                                      ).withAlpha(140),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Obx(
                              () => Slider(
                                label: "price \$ ${controller.price.value}",
                                divisions: 120,
                                min: 0,
                                max: 1000,
                                value: controller.price.value.toDouble(),
                                onChanged: (value) {
                                  controller.price.value = value.toInt();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(1), // الظل
                 // لون الزر
                  foregroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ), // لون النص
                  overlayColor: MaterialStateProperty.resolveWith<Color?>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blueAccent.withOpacity(
                        0.3,
                      ); // لون عند الضغط
                    }
                    return null; // باقي الحالات تستخدم اللون الافتراضي
                  }),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // الزوايا الدائرية
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ), // المساحة الداخلية
                  ),
                ),

                child: Icon(
                  size: 20,
                  Icons.filter_alt_rounded,
                  color: const Color.fromARGB(221, 7, 140, 173).withAlpha(140),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leadingWidth: 70, // زيادة العرض قليلاً عشان الدايرة متتحشرش
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Center(
            child: Hero(
              // تأكد أن الـ tag فريد لكل صفحة
              tag: "Items",
              child: Container(
                width: 45, // حجم متناسق أكتر مع الـ AppBar
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  // ضروري جداً داخل Hero عشان الـ Splash يظهر صح
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      // ✅ حماية: اقفل أي رسالة مفتوحة قبل ما ترجع
                      Navigator.of(context).pop();
                      // ✅ رجوع للصفحة السابقة
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    iconSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            children: [
              /// 📂 القائمة الأفقية للأقسام
              Container(
                margin: EdgeInsets.only(
                  top: height * 0.01,
                  bottom: height * 0.01,
                ),
                height: height * 0.07, // متجاوبة مع أي شاشة
                width: width,
                child: ListCatigoriesItem(),
              ),

              /// 🛍 شبكة العناصر (المنتجات)
              Expanded(
                child: GetBuilder<ItemsControler>(
                  builder: (controller) => Handlingdataview(
                    statusrequest: controller.statusrequest,
                    widget: !controller.issearch
                        ? GridView.builder(
                            padding: EdgeInsets.all(width * 0.03),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: width / (height * 0.60),
                                  crossAxisSpacing: width * 0.03,
                                  mainAxisSpacing: height * 0.02,
                                ),
                            itemCount: controller.data.length,
                            itemBuilder: (context, i) {
                              favController.isfavorite[controller
                                      .data[i]
                                      .itemsId] =
                                  controller.data[i].favorite;
                              return _buildItemCard(context, i, width, height);
                            },
                          )
                        : Searchpage(searchdata: controller.searchlist),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🖼️ كارت بعرض ثلاثي الأبعاد
  Widget _buildItemCard(
    BuildContext context,
    int index,
    double width,
    double height,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // حواف ناعمة
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51), // 0.2 * 255 = 51
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: width * 0.45, // عرض نسبي لكل كارت
          height: height * 0.28, // ارتفاع نسبي لكل كارت
          child: ItemsCard(i: index),
        ),
      ),
    );
  }
}

Widget filtercard(String title) {
  return InkWell(
    onTap: () {},
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(60),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: const Color.fromARGB(179, 148, 146, 146),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
