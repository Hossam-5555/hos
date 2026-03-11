import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/myfavcontroler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/myfavorite.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';

class Myfavorite extends StatelessWidget {
  const Myfavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Get.put(Myfavcontroler());
    return Scaffold(
      appBar: AppBar(leading: BackButtonCircle(), title: Text("Favorite".tr)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GetBuilder<Myfavcontroler>(
                builder: (controller) => Handlingdataview(
                  statusrequest: controller.statusrequest,
                  widget: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.data.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                      vertical: height * 0.015,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: width / (height * 0.70), // نسبي
                      crossAxisSpacing: width * 0.03,
                      mainAxisSpacing: height * 0.015,
                    ),
                    itemBuilder: (context, i) =>
                        FavCard(items: controller.data[i]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FavCard extends GetView<Myfavcontroler> {
  final myfavoritemodel items;
  const FavCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // استخدمنا الكارت الموحد هنا!
    return SharedProductCard(
      image: "${LinkApi.imageitems}/${items.itemsImage}",
      title: items.itemsName ?? "بدون اسم",
      price: "${items.itemsPrice ?? "0"} ج.م",
      rating: 4.5, // لو الموديل فيه تقييم حطه هنا
      onTap: () {
        // controller.gotoitemsdatails(items);
      },
      // 👈 هنا بنصمم الزرار الخاص بصفحة المفضلة (زرار الحذف)
      actionButton: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(), // عشان نشيل المسافات الافتراضية للزرار
        onPressed: () {
          controller.deletefromfavpage(items.favId.toString());
        },
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.redAccent,
          size: 24,
        ),
      ),
    );
  }
}