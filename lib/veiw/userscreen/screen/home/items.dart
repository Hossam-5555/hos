// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/items/productcard.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // مقاسات الشاشة
    final height = size.height;
    final width = size.width;

    ItemsControler controller = Get.put(ItemsControler());
    Get.put(FavController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomItemsAppBar(controller: controller, width: width),
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (_, i) {
                    final catmodel = controller.categories[i];
                    final icon = "${catmodel.image}";
                    return BuildCategoryItems(
                      catmodel: catmodel,
                      urlIcon: icon,
                      i: i,
                    );
                  },
                ),
              ),

              /// 🛍 شبكة العناصر (المنتجات)
              Expanded(
                child: GetBuilder<ItemsControler>(
                  builder: (controller) => Handlingdataview(
                    statusrequest: controller.statusrequest,
                    widget: GridView.builder(
                      // padding ممتاز
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: 10,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // رقم ثابت يضمن إن الكارت مستطيل مناسب لشكل الـ E-commerce
                        childAspectRatio: 0.65,
                        crossAxisSpacing: width * 0.03,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: controller.data.length,
                      itemBuilder: (context, i) {
                        // تم إزالة سطر الـ favController من هنا للحفاظ على سلاسة السكرول
                        return ItemsCard(i: i);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget filtercard(String title, int isSelected) {
  return InkWell(
    onTap: () {
      Get.find<ItemsControler>().filtesortedby(isSelected);
    },
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Get.find<ItemsControler>().selectedfilter == isSelected
              ? Appcolor.primaryColor.withAlpha(140)
              : Colors.grey.withAlpha(60),
          width: 1,
        ),
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
