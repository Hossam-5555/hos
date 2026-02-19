import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/shoppage/checkout.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Checkoutcontroller());
    double hight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.grey[50], // لون خلفية هادئ يبرز البطاقات
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Appbarbackicon(herotag: '', title: "Checkout"),
      ),
      body: GetBuilder<Checkoutcontroller>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: Column(
              children: [
                // 📜 القسم العلوي القابل للتمرير (طرق الدفع والعناوين)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 💳 Payment Section
                        Row(
                          children: [
                            Icon(Icons.payment_rounded, color: Appcolor.primaryColor, size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              "Payment Method",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.paymentMethods.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 12),
                            itemBuilder: (context, index) => Listpaymentcard(
                              image: controller.paymentMethods[index][1],
                              onTap: () => controller.choospaymentmethod(index),
                              isActive: controller.paymenttype == index,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        const Divider(thickness: 1, color: Colors.black12),
                        const SizedBox(height: 20),

                        // 🏠 Address Section
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: Appcolor.primaryColor, size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              "Delivery Address",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (controller.listaddresdata.isEmpty)
                          _buildEmptyAddressCard()
                        else
                          SizedBox(
                            height: 130,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              clipBehavior: Clip.none, // لمنع قطع الظلال
                              separatorBuilder: (_, __) => const SizedBox(width: 16),
                              itemCount: controller.listaddresdata.length,
                              itemBuilder: (context, index) {
                                final address = controller.listaddresdata[index];
                                final isActive = controller.addressid == address.addresId;

                                return GestureDetector(
                                  onTap: () => controller.chooseAddres(address.addresId!.toInt()),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    width: 240,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isActive ? Appcolor.primaryColor : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isActive ? Appcolor.primaryColor : Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        if (isActive)
                                          BoxShadow(
                                            color: Appcolor.primaryColor.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        else
                                          const BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              address.addresName ?? "No Name",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isActive ? Colors.white : Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${address.addresStreet} - ${address.addresCity}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                height: 1.4,
                                                color: isActive ? Colors.white70 : Colors.grey[600],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        if (isActive)
                                          const Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(Icons.check_circle, color: Colors.white, size: 20),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 💰 القسم السفلي الثابت (ملخص السعر وزر التأكيد)
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // يأخذ مساحة المحتوى فقط
                    children: [
                      _buildPriceRow("Subtotal", controller.totalprice),
                      _buildPriceRow("Tax (10%)", "40.0"),
                      _buildPriceRow("Shipping", "10.0"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(thickness: 1, color: Colors.black12),
                      ),
                      _buildPriceRow("Total", controller.totalprice, isTotal: true),
                      const SizedBox(height: 24),
                      
                      // ✅ Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolor.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            controller.checkoutoder(hight - 100);
                          },
                          child: const Text(
                            "Confirm Order",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🏡 بطاقة إضافة عنوان في حال كانت القائمة فارغة
  Widget _buildEmptyAddressCard() {
    return GestureDetector(
      onTap: () {
        Get.offAll(
          () => AddNewAddres(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Appcolor.primaryColor.withOpacity(0.05),
          border: Border.all(color: Appcolor.primaryColor.withOpacity(0.3), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Appcolor.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_location_alt_rounded, color: Appcolor.primaryColor),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'No addresses found, tap to add one.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 💰 Price Row Widget
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Text(
            "\$$value",
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
              color: isTotal ? Appcolor.primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}