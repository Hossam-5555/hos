import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homepage_controller.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/itemsmodel.dart';

class ItemsCardhome extends GetView<HomepageController> {
  final int index;
  const ItemsCardhome({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    if (controller.items.isEmpty || controller.items[index] == null) {
      return const SizedBox(); // تجنب الكراش
    }
    return ItemList(items: Itemsmodel.fromJson(controller.items[index]));
  }
}

class ItemList extends GetView<HomepageController> {
  final Itemsmodel items;
  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        controller.gotoitemsdatails(items);
      },
      child: Container(
        height: 220,
        width: 250,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼 صورة المنتج مع Hero + ClipRRect
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Card(
                child: Image.network(
                  "${LinkApi.imageitems}/${items.itemsImage}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: size.height * 0.18,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            /// 📝 اسم المنتج

            /// 💰 السعر وزرار صغير
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        items.itemsName ?? "بدون اسم",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "${items.itemsPrice ?? "0"} ج.م",
                        style: TextStyle(
                          fontSize: size.width * 0.033,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    // padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 4, 4, 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
