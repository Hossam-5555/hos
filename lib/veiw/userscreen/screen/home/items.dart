import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/favorite/fav_controller.dart';
import 'package:hos/controler/home/items_controler.dart';
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
    ItemsControler controller = Get.put(ItemsControler());
    FavController favController = Get.put(FavController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(title: "Items", herotag: "carttag"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /// 🔍 شريط البحث
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Searchbar(
                  onPressedIcon: () {
                    controller.onsearch();
                  },
                  onChanged: (val) {
                    controller.checksearch(val);
                  },
                  title: "ابحث عن منتج...",
                  mycontroller: controller.search!,
                ),
              ),

              /// 📂 القائمة الأفقية للأقسام
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 10),
                height: size.height * 0.07, // متجاوبة مع أي شاشة
                width: size.width,
                child: listcatigoriesitem(),
              ),

              /// 🛍 شبكة العناصر (المنتجات)
              GetBuilder<ItemsControler>(
                builder: (controller) => Handlingdataview(
                  statusrequest: controller.statusrequest,
                  widget: !controller.issearch
                      ? Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.70,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: controller.data.length,
                            itemBuilder: (context, i) {
                              favController.isfavorite[controller
                                      .data[i]
                                      .itemsId] ==
                                  controller.data[i].favorite;
                              return _buildItemCard(i);
                            },
                          ),
                        )
                      : Searchpage(searchdata: controller.searchlist),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🖼️ كارت بعرض ثلاثي الأبعاد
  Widget _buildItemCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // حواف ناعمة
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // ظل خفيف
            blurRadius: 8, // مدى الانتشار
            offset: const Offset(2, 4), // اتجاه الظل (يمين وتحت)
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ItemsCard(i: index), // الكارت الأصلي بتاعك
      ),
    );
  }
}
