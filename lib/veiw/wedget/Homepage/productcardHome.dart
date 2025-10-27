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
      return const SizedBox();
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
    final width = size.width;
    final height = size.height;

    return GestureDetector(
      onTap: () => controller.gotoitemsdatails(items),
      child: ClipPath(clipper:TrapezoidClipper() ,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.008,
          ),
          height: height * 0.32, // ✨ خففنا الارتفاع العام للكارت
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 🖼 الصورة
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.network(
                  "${LinkApi.imageitems}/${items.itemsImage}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height * 0.21, // ✨ قللنا ارتفاع الصورة
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),
        
              // 🔹 الجزء السفلي (أعرض وبارز)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.012,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 📝 اسم المنتج والسعر
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              items.itemsName ?? "بدون اسم",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: height * 0.004),
                            Text(
                              "${items.itemsPrice ?? "0"} ج.م",
                              style: TextStyle(
                                fontSize: width * 0.042,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
        
                      // 🛒 زر الشراء (أكبر شوية وواضح)
                      Container(
                        height: height * 0.06,
                        width: height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_basket_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
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
class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(10, 0); // فوق يمين مائل بسيط
    path.lineTo(size.width - 10, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}