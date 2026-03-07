import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/myfavcontroler.dart';
import 'package:hos/core/conistant/linkApi.dart';

import 'package:hos/data/model/myfavorite.dart';

// ignore: must_be_immutable
class FavCard extends GetView<Myfavcontroler> {
  final myfavoritemodel items;
  const FavCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45; // 45% من عرض الشاشة
    final cardHeight = cardWidth * 1.3; // نسبة طول للكارت

    return GestureDetector(
      onTap: () {
        // controller.gotoitemsdatails(items);
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 119, 119, 121),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38), // 15% transparency
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              /// صورة المنتج
              Positioned.fill(
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

              /// خلفية شفافة للنصوص
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(128), // 50% transparency
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
                          fontSize: 12,
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
                                    size: 15,
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
                            "${items.itemsPrice ?? "0"} ج.م",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.deletefromfavpage(
                                items.favId.toString(),
                              );
                            },
                            icon: Icon(Icons.delete_outline,
                                color: Colors.red.shade400),
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
