import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/myfavcontroler.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/shared_product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Myfavorite extends StatelessWidget {
  Myfavorite({super.key});
  final c = Get.put(Myfavcontroler());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: Appbarbackicon(
        herotag: "Favorite".tr,
        title: "My Favorite",
        selected: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GetBuilder<Myfavcontroler>(
                builder: (controller) => HandlingDataView(
                  emptyStyle: EmptyStateStyle.style2,
                  statusrequest: controller.statusrequest,
                  mediaType: HandlingMediaType.svgImage,
                  mode: HandlingMode.fullScreen,
                  widget: Skeletonizer(
                    containersColor: Colors.grey.withAlpha(90),
                    enabled: controller.statusrequest == Statusrequest.loading,
                    child: GridView.builder(
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

                      itemBuilder: (context, i) {
                        final items = controller.data[i];
                        return SharedProductCard(
                          height: 220,
                          items: items.item!,

                          onTap: () {
                            // controller.gotoitemsdatails(items);
                          },
                          // 👈 هنا بنصمم الزرار الخاص بصفحة المفضلة (زرار الحذف)
                          actionButton: IconButton(
                            padding: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints(), // عشان نشيل المسافات الافتراضية للزرار
                            onPressed: () {
                              controller.deletefromfavpage(items.item!.id!);
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 24,
                            ),
                          ),
                          isen: c.lang == "en" ? true : false,
                        );
                      },
                    ),
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
