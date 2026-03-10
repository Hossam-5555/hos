import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/myfavcontroler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/myfavcard.dart';

class Myfavorite extends StatelessWidget {
  const Myfavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Get.put(Myfavcontroler());
    return Scaffold(
      appBar: AppBar(leading: BackButtonCircle()),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Padding(
            //   padding: EdgeInsets.all(width * 0.03), // Padding نسبي
            //   child:
            // ),
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
