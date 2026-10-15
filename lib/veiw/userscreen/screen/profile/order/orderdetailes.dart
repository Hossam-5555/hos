import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/controler/usercontroller/profile/order/orderdetailescontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';

class Orderdetailes extends StatelessWidget {
  const Orderdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Orderdetailescontroller());
    Get.find<Ordercontroller>();

    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: c.order?.orderNumber ?? ''),
      ),

      body: GetBuilder<Orderdetailescontroller>(
        builder: (_) {
          final order = c.order;

          if (order == null) {
            return const Center(child: Text("No Data"));
          }

          c.Getcolorandstause(order.status);

          return ListView(
            padding: EdgeInsets.fromLTRB(w * 0.04, 10, w * 0.04, 30),
            children: [
              // ============================================================
              // ORDER STATUS
              // ============================================================
              orderStatusSection(
                order,
                c.statusColor ?? Colors.black,
                c.statusText ?? order.status,
              ),

              const SizedBox(height: 12),

              // ============================================================
              // PAYMENT
              // ============================================================
              paymentSection(
                context: context,
                order: order,
                controller: c,
                width: w,
              ),

              const SizedBox(height: 12),

              // ============================================================
              // ITEMS
              // ============================================================
              sectionCard(
                context,
                title: "product".tr,
                icon: Icons.shopping_bag_outlined,
                child: itemsSection(order),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // DELIVERY DETAILS
              // ============================================================
              sectionCard(
                context,
                title: "Delivery Details",
                icon: Icons.location_on_outlined,
                child: deliveryDetails(order),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // ORDER SUMMARY
              // ============================================================
              sectionCard(
                context,
                title: "Order Summary".tr,
                icon: Icons.receipt_long_outlined,
                child: orderSummary(order),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // CANCEL ORDER
              // ============================================================
              if (order.status.toLowerCase() == "pending")
                GetBuilder<Ordercontroller>(
                  builder: (controller) {
                    return Checkbutton(
                      statusrequest: controller.statusrequest,
                      buttonColor: Colors.black,
                      width: w,
                      onTap: () {
                        controller.deleteorders(order.orderId);
                      },
                      buttonName: "Cancel Order",
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// SECTION CARD
// ============================================================================
