import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hos/controler/admincontroller/order/orderdetailscontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/order/detailsorder.dart';

class AdminOrderdetails extends StatelessWidget {
  const AdminOrderdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminOrderDetailesController());
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(
          herotag: '',
          title: controller.order?.orderNumber ?? '',
        ),
      ),

      body: GetBuilder<AdminOrderDetailesController>(
        builder: (_) {
          final o = controller.order;

          if (o == null) {
            return const Center(child: Text("No Data"));
          }

          controller.getcolorandstause(o.status);

          return ListView(
            padding: EdgeInsets.fromLTRB(w * 0.04, 10, w * 0.04, 100),
            children: [
              // ============================================================
              // ORDER STATUS
              // ============================================================
              statusorder(
                controller.currentStatus,
                controller.statusColor!,
                controller.statusText!,
              ),

              const SizedBox(height: 12),

              // ============================================================
              // QUICK ACTIONS
              // ============================================================
              _quickActions(context, o, controller),

              const SizedBox(height: 12),

              // ============================================================
              // CUSTOMER DETAILS
              // ============================================================
              CardWidget(child: info(o)),

              const SizedBox(height: 12),

              // ============================================================
              // ORDER ITEMS
              // ============================================================
              CardWidget(child: items(o)),

              const SizedBox(height: 12),

              // ============================================================
              // PAYMENT
              // ============================================================
              _paymentCard(context, o),

              const SizedBox(height: 12),

              // ============================================================
              // ORDER SUMMARY
              // ============================================================
              CardWidget(child: price(o)),

              const SizedBox(height: 20),
            ],
          );
        },
      ),

      // ================================================================
      // CHANGE STATUS BUTTON
      // ================================================================
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: GetBuilder<AdminOrderDetailesController>(
        builder: (_) {
          final o = controller.order;

          if (o == null) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(
              left: w * 0.04,
              right: w * 0.04,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            child: Checkbutton.widget(
              width: w * 0.9,
              h: 50,
              buttonColor:
                  controller.statusColor ?? Theme.of(context).primaryColor,
              statusrequest: Statusrequest.none,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_note, color: Colors.white, size: 24),

                  const SizedBox(width: 8),

                  Text(
                    controller.currentStatus == 'delivered' ||
                            controller.currentStatus == 'cancelled'
                        ? "لا يمكن التعديل علي حاله الطلب"
                        : "Change Order Status",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              onTap: () {
                _showStatusBottomSheet(context, controller);
              },
              buttonName: "orderstate",
            ),
          );
        },
      ),
    );
  }

  // ========================================================================
  // QUICK ACTIONS
  // ========================================================================

  Widget _quickActions(
    BuildContext context,
    dynamic order,
    AdminOrderDetailesController controller,
  ) {
    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on_outlined, size: 21),

              const SizedBox(width: 9),

              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.phone_outlined,
                  title: "Call Customer",
                  onTap: () {
                    controller.makePhoneCall();
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Obx(() {
                  return controller.istracking.value
                      ? const Center(child: CircularProgressIndicator())
                      : _actionButton(
                          icon: Icons.location_on_outlined,
                          title: "Track Order",
                          onTap: () {
                            controller.openMap(
                              lat: controller.order!.shippingAddress.lat ?? 0.0,
                              lng: controller.order!.shippingAddress.lng ?? 0.0,
                            );
                          },
                        );
                }),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ========================================================================
  // ACTION BUTTON
  // ========================================================================

  Widget _actionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withAlpha(45)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 21),

              const SizedBox(height: 4),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================================================
  // PAYMENT CARD
  // ========================================================================

  Widget _paymentCard(BuildContext context, dynamic order) {
    final paymentStatus = order.paymentStatus.toString().toLowerCase();

    final isPaid = paymentStatus == "paid";

    final isFailed = paymentStatus == "failed";

    final Color statusColor = isPaid
        ? Colors.green
        : isFailed
        ? Colors.red
        : Colors.orange;

    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payment_outlined, size: 21),

              const SizedBox(width: 9),

              const Text(
                "Payment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _paymentRow(
            "Status",
            isPaid
                ? "Paid"
                : isFailed
                ? "Failed"
                : "Pending",
            statusColor,
          ),

          const SizedBox(height: 10),

          _paymentRow(
            "Method",
            order.paymentMethod.toString(),
            Colors.grey.shade700,
          ),

          // Transaction ID
          //
          // لما تضيف transactionId في الـ Model
          // نقدر نعرضه هنا.
        ],
      ),
    );
  }

  // ========================================================================
  // PAYMENT ROW
  // ========================================================================

  Widget _paymentRow(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),

        Row(
          children: [
            if (title == "Status")
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),

            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========================================================================
  // STATUS BOTTOM SHEET
  // ========================================================================

  void _showStatusBottomSheet(
    BuildContext context,
    AdminOrderDetailesController controller,
  ) {
    final currentStatus = controller.currentStatus;

    if (currentStatus == 'delivered' || currentStatus == 'cancelled') {
      Get.snackbar("تنبيه", "هذا الطلب منتهي ولا يمكن تعديل حالته.");

      return;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "Change the current order status",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),

            const Divider(height: 25),

            if (currentStatus == 'pending') ...[
              _buildStatusTile(
                "Accept & Process Order",
                controller.statusColor,
                () => controller.updateStatus('processing'),
              ),

              _buildStatusTile(
                "Cancel Order",
                Colors.red,
                () => controller.updateStatus('cancelled'),
              ),
            ],

            if (currentStatus == 'processing') ...[
              _buildStatusTile(
                "Assign / Ship to Courier",
                controller.statusColor,
                () => controller.updateStatus('shipped'),
              ),

              _buildStatusTile(
                "Cancel Order",
                Colors.red,
                () => controller.updateStatus('cancelled'),
              ),
            ],

            if (currentStatus == 'shipped') ...[
              _buildStatusTile(
                "Mark as Delivered",
                controller.statusColor,
                () => controller.updateStatus('delivered'),
              ),
            ],
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  // ========================================================================
  // STATUS TILE
  // ========================================================================

  Widget _buildStatusTile(String title, Color? color, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: CircleAvatar(radius: 7, backgroundColor: color ?? Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: color ?? Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
