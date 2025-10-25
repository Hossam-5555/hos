import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/favorite/fav_controller.dart';
import 'package:hos/controler/offercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/items/offer/offercard.dart';

class Offer extends StatelessWidget {
  const Offer({super.key});

  @override
  Widget build(BuildContext context) {
    Offercontroller controller = Get.put(Offercontroller());
    FavController favController = Get.put(FavController());

    return Scaffold(
      body: GetBuilder<Offercontroller>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: ListView.builder(
              itemBuilder: (context, index) {
                return Offercard( index: index);
              },
              itemCount: controller.offerList.length,
            ),
          );
        },
      ),
    );
  }
}
