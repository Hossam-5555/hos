import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/buttom.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/countofproduct.dart';

class Itemsdetailes extends StatelessWidget {
  final Itemdetailscontroller controller = Get.put(Itemdetailscontroller());

  Itemsdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      body: GetBuilder<Itemdetailscontroller>(
        builder: (_) {
          final item = controller.itemsmodel;
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: [
              // ✅ الصورة (النصف العلوي)
              Positioned(
                top: h * 0.10, // عشان تكون في منتصف الجزء العلوي
                left: 0,
                right: 0,
                child: SizedBox(
                  height: h * 0.35, // ارتفاع متوسط يناسب النص العلوي
                  width: w * 0.7,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        233,
                        228,
                        219,
                      ).withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Hero(
                      tag: '${item.itemsId}',
                      child: Image.network(
                        "${LinkApi.imageitems}/${item.itemsImage!}",
                        height: h * 0.38, // ارتفاع متوسط يناسب النص العلوي
                        width: w * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ التفاصيل (النصف السفلي)
              Positioned(
                top: h * 0.50,
                child: Container(
                  height: h * 0.50,
                  width: w,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: h * 0.03),
                      // ===== الاسم والسعر =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemsName ?? '',
                                  style: TextStyle(
                                    fontSize: w * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.itemsDesc ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${(item.itemspricediscount ?? '100').toString().substring(0, (item.itemspricediscount ?? '100').length.clamp(0, 6))}\$",
                            style: TextStyle(
                              fontSize: w * 0.055,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.02),

                      // ===== التقييم وعدد القطع =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              4,
                              (index) => Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: w * 0.06,
                              ),
                            ),
                          ),
                          Countofproduct(count: controller.itemcount),
                        ],
                      ),

                      SizedBox(height: h * 0.03),

                      // ===== الوصف =====
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "هذا وصف تفصيلي للمنتج يوضح كل الخصائص والمميزات "
                        "مع شرح كامل يساعد المستخدم في معرفة التفاصيل قبل الشراء.",
                        style: TextStyle(fontSize: w * 0.04, height: 1.6),
                      ),
                      Spacer(),
                      // ===== الزر =====
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: h * 0.04),
                        child: Buttom(),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: h * 0.05,
                left: w * 0.05,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withAlpha(55),
                        offset: Offset(0.5, 1),
                      ),
                    ],
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
              Positioned(
                top: h * 0.480,
                left: w * 0.05,
                child: Transform.rotate(
                  angle: -math.pi / 30.0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            89,
                            89,
                            89,
                          ).withAlpha(50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.rocket_launch_sharp),
                            Text(
                              "Hot product",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Italic',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
