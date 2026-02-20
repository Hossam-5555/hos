import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/offercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/items/offer/offercard.dart';

class Offer extends StatelessWidget {
  const Offer({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Offercontroller());
    Get.put(FavController());

    return Scaffold(
      backgroundColor: Colors.grey[100],

   

      body: GetBuilder<Offercontroller>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: Column(
              children: [
                // 🔥 بانر أعلى الصفحة
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.red, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_offer,
                          color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "عروض خاصة لفترة محدودة ⏳",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🧠 الحالة الفاضية
                if (controller.offerList.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "لا توجد عروض حالياً",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                else
                  // 📦 قائمة العروض
                  Expanded(
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: controller.offerList.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return Offercard(index: index);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}