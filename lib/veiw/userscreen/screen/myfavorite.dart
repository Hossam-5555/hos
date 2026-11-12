import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/myfavcontroler.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/shared_product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Myfavorite extends StatelessWidget {
  Myfavorite({super.key});

  final c = Get.put(Myfavcontroler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarbackicon(
        herotag: "Favorite".tr,
        title: "My Favorite",
        selected: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // المساحة المتاحة فعلياً بعد خصم الـ AppBar
            final width = constraints.maxWidth;

            // تحديد عدد الأعمدة حسب عرض الشاشة
            final int crossAxisCount;

            if (width >= 1100) {
              crossAxisCount = 5;
            } else if (width >= 850) {
              crossAxisCount = 4;
            } else if (width >= 600) {
              crossAxisCount = 3;
            } else {
              crossAxisCount = 2;
            }

            // الحفاظ على عرض مناسب للكارت
            const horizontalPadding = 12.0;
            const crossAxisSpacing = 12.0;

            final availableWidth = width - (horizontalPadding * 2);

            final cardWidth =
                (availableWidth - (crossAxisSpacing * (crossAxisCount - 1))) /
                crossAxisCount;

            // ارتفاع الكارت يتناسب مع عرضه
            final cardHeight = cardWidth * 1.48;

            return GetBuilder<Myfavcontroler>(
              builder: (controller) => HandlingDataView(
                emptyStyle: EmptyStateStyle.style2,
                statusrequest: controller.statusrequest,
                mediaType: HandlingMediaType.svgImage,
                mode: HandlingMode.fullScreen,
                widget: Skeletonizer(
                  containersColor: Colors.grey.withAlpha(90),
                  enabled: controller.statusrequest == Statusrequest.loading,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 12,
                    ),
                    itemCount: controller.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: 14,
                      mainAxisExtent: cardHeight,
                    ),
                    itemBuilder: (context, i) {
                      final items = controller.data[i];

                      return SharedProductCard(
                        height: cardHeight,
                        items: items.item!,
                        onTap: () {
                          controller.gotoitemsdatails(items.item!);
                        },
                        actionButton: Homescrenaction(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            controller.deletefromfavpage(items.item!.id!);
                          },
                          herotag: "itemdelete${items.item!.id}",
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                        ),
                        isen: c.lang == "en",
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
