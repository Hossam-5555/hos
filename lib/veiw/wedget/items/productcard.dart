import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:lottie/lottie.dart';

class ItemsCard extends GetView<ItemsControler> {
  final int i;
  const ItemsCard({super.key, required this.i});

  @override
  Widget build(BuildContext context) {
    return ItemList(index: i, active: true, items: controller.data[i]);
  }
}

// ignore: must_be_immutable
class ItemList extends GetView<ItemsControler> {
  final Itemsmodel items;
  bool active;
  ItemList({
    super.key,
    required this.items,
    required this.active,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45; // 45% من عرض الشاشة
    final cardHeight = cardWidth * 1.3; // نسبة طول للكارت

    return GestureDetector(
      onTap: () {
        controller.gotoitemsdatails(items);
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 119, 119, 121),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              /// صورة المنتج
              Positioned.fill(
                child: Hero(
                  tag: '${items.itemsId}',
                  child: Image.network(
                    "${LinkApi.imageitems}/${items.itemsImage}",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GetBuilder<FavController>(
                  builder: (controller) {
                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(90),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (controller.isfavorite[items.itemsId] == "1") {
                            controller.chasngfav(items.itemsId, "0");
                            controller.removefromfav(items.itemsId!.toString());
                          } else {
                            controller.chasngfav(items.itemsId, "1");
                            controller.addfav(items.itemsId!.toString());
                          }
                        },
                        icon: Icon(
                          controller.isfavorite[items.itemsId] == "1"
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: controller.data[index].itemsDiscount != "0.00"
                    ? Container(
                        height: 70,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Transform.rotate(
                          angle: 0.70,
                          child: Lottie.asset(Imageasset.sale),
                        ),
                      )
                    : SizedBox.shrink(),
              ),

              /// خلفية شفافة للنصوص
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(60), // 0.5 opacity in alpha value (255 * 0.5 = 128)
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// اسم المنتج
                      Text(
                        items.itemsName ?? "بدون اسم",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 24, // ارتفاع مناسب للنجوم + النص
                        width: cardWidth * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// نجوم التقييم
                            Row(
                              children: List.generate(
                                5,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  child: Icon(
                                    index <
                                            4 // لو التقييم 4.3 → يلون أول 4 نجوم
                                        ? Icons.star
                                        : Icons.star_border_outlined,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 6),

                            /// الرقم بجانب النجوم
                            const Text(
                              "4.3",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// السعر + المفضلة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${double.parse(items.itemspricediscount.toString()).toStringAsFixed(2)} ج.م",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
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
