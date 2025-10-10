import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:hos/controler/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/wedget/shoppage/checkout.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    // عناوين افتراضية (Placeholder)
    Get.put(Checkoutcontroller());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: Padding(
          // الخطوة 1: إضافة هامش قياسي ليكون بعيدًا عن الحافة
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                // إضافة ظل خفيف ليعطي عمقاً
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 24, // الخطوة 4: تحديد حجم قياسي للأيقونة
              splashRadius: 24, // لجعل تأثير الضغط لا يخرج عن الدائرة
            ),
          ),
        ),
      ),
      body: GetBuilder<Checkoutcontroller>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // 🏠 اختيار العنوان
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: const Text("Select Address"),
                ),

                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.ListAddresdata.length,
                    itemBuilder: (context, index) => Listaddrescard(
                      onTap: () {
                        controller.chooseAddres(
                          controller.ListAddresdata[index].addresId,
                        );
                      },
                      isActive:
                          controller.Addressid ==
                              controller.ListAddresdata[index].addresId
                          ? true
                          : false, // 🔥 مقارنة مباشرة

                      titil: "${controller.ListAddresdata[index].addresName}",
                      subtitle:
                          "${controller.ListAddresdata[index].addresStreet}-${controller.ListAddresdata[index].addresCity}",
                    ),
                  ),
                ),

                const Divider(height: 30, thickness: 1),

                // 💳 اختيار وسيلة الدفع
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: const Text("Payment Method"),
                ),

                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.addresses.length,
                    itemBuilder: (context, index) => Listpaymentcard(
                      image: controller.paymentMethods[index][1],
                      onTap: () {
                        controller.choospaymentmethod(
                          index,
                        ); // 🔥 نرسل index المختار
                      },
                      isActive:
                          controller.Paymenttype == index, // 🔥 مقارنة مباشرة
                    ),
                  ),
                ),

                const Divider(height: 32, thickness: 1),

                // 💰 السعر النهائي
                _buildPriceRow("Subtotal", "${controller.totalprice}"),
                _buildPriceRow("Tax (10%)", "40.0"),
                _buildPriceRow("Shipping", "10"),
                const Divider(height: 32, thickness: 1),
                _buildPriceRow("Total", controller.totalprice, isTotal: true),

                // ✅ زرار الدفع
                Container(
                  margin: EdgeInsets.only(top: 24),
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      controller.checkoutoder();
                    },
                    child: const Text(" Confirm Order "),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 💰 ويدجت الأسعار
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "\$${value}",
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? Colors.green
                  : const Color.fromARGB(255, 131, 188, 98),
            ),
          ),
        ],
      ),
    );
  }
}
