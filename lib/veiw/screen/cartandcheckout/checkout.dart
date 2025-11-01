import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/shoppage/checkout.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Checkoutcontroller());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Appbarbackicon(herotag: '', title: "Checkout"),
      ),
      body: GetBuilder<Checkoutcontroller>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 💳 Payment Section
                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.paymentMethods.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) => Listpaymentcard(
                        image: controller.paymentMethods[index][1],
                        onTap: () => controller.choospaymentmethod(index),
                        isActive: controller.Paymenttype == index,
                      ),
                    ),
                  ),
                  const Divider(height: 40, thickness: 1),

                  // 🏠 Address Section
                  const Text(
                    "Select Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (controller.ListAddresdata.isEmpty)
                    GestureDetector(
                      onTap: () {
                        Get.offAll(
                          () => addnewaddres(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 400),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        child: const ListTile(
                          leading: Icon(Icons.add_location_alt_rounded,
                              color: Colors.blueAccent),
                          title: Text(
                            'Add Address',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle:
                              Text('No addresses found, tap to add one.'),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 10),
                        itemCount: controller.ListAddresdata.length,
                        itemBuilder: (context, index) => Listaddrescard(
                          onTap: () {
                            controller.chooseAddres(
                              controller.ListAddresdata[index].addresId,
                            );
                          },
                          isActive: controller.Addressid ==
                              controller.ListAddresdata[index].addresId,
                          titil:
                              "${controller.ListAddresdata[index].addresName}",
                          subtitle:
                              "${controller.ListAddresdata[index].addresStreet} - ${controller.ListAddresdata[index].addresCity}",
                        ),
                      ),
                    ),

                  const Divider(height: 40, thickness: 1),

                  // 💰 Price Summary
                  _buildPriceRow("Subtotal", controller.totalprice),
                  _buildPriceRow("Tax (10%)", "40.0"),
                  _buildPriceRow("Shipping", "10"),
                  const Divider(height: 32, thickness: 1),
                  _buildPriceRow("Total", controller.totalprice, isTotal: true),

                  // ✅ Confirm Button
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolor.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          controller.checkoutoder();
                        },
                        child: const Text(
                          "Confirm Order",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 💰 Price Row Widget
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey[800],
            ),
          ),
          Text(
            "\$$value",
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.green[700] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
