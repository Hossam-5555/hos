import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08), // نسبي
        child: Appbarbackicon(title: "Items", herotag: "carttag"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            children: [
              /// 🔍 شريط البحث
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.015, horizontal: width * 0.01),
                child: Searchbar(
                  onPressedIcon: controller.onsearch,
                  onChanged: controller.checksearch,
                  title: "ابحث عن منتج...",
                  mycontroller: controller.search!,
                ),
              ),

              /// 📂 القائمة الأفقية للأقسام
              Container(
                margin: EdgeInsets.only(top: height * 0.02, bottom: height * 0.015),
                height: height * 0.08, // متجاوبة مع أي شاشة
                width: width,
                child: listcatigoriesitem(),
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
                              childAspectRatio: width / (height * 0.55),
                              crossAxisSpacing: width * 0.03,
                              mainAxisSpacing: height * 0.02,
                            ),
                            itemCount: controller.data.length,
                            itemBuilder: (context, i) {
                              favController.isfavorite[controller.data[i].itemsId] =
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
  Widget _buildItemCard(BuildContext context, int index, double width, double height) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // حواف ناعمة
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
