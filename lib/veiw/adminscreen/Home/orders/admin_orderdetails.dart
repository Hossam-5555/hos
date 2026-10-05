import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hos/controler/admincontroller/order/orderdetailscontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orderdetailes.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class AdminOrderdetails extends StatelessWidget {
  const AdminOrderdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminOrderDetailesController());
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
            // 100 سفلي عشان زرار تغيير الحالة العايم
            padding: EdgeInsets.fromLTRB(w * 0.04, 10, w * 0.04, 100),
            children: [
              // ============================================================
              // ORDER STATUS
              // ============================================================
              orderStatusSection(
                o,
                controller.statusColor ?? Colors.black,
                controller.statusText ?? o.status,
              ),

              const SizedBox(height: 12),

              // ============================================================
              // QUICK ACTIONS (admin only)
              // ============================================================
              _quickActions(context, o, controller, o.username),

              const SizedBox(height: 12),

              // ============================================================
              // PAYMENT
              // ============================================================
              _paymentSection(context, o),

              const SizedBox(height: 12),

              // ============================================================
              // ITEMS
              // ============================================================
              sectionCard(
                context,
                title: "Items",
                icon: Icons.shopping_bag_outlined,
                child: itemsSection(o),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // DELIVERY DETAILS
              // ============================================================
              sectionCard(
                context,
                title: "Delivery Details",
                icon: Icons.location_on_outlined,
                child: deliveryDetails(o),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // ORDER SUMMARY
              // ============================================================
              sectionCard(
                context,
                title: "Order Summary",
                icon: Icons.receipt_long_outlined,
                child: orderSummary(o),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),

      // ================================================================
      // CHANGE STATUS BUTTON (admin only)
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
    String customerName,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : const Color(0xFFE0E3E8),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Customer",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Obx(() {
            return controller.istracking.value
                ? const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : _circleButton(Icons.location_on, () {
                    controller.openMap(
                      lat: controller.order!.shippingAddress.lat ?? 0.0,
                      lng: controller.order!.shippingAddress.lng ?? 0.0,
                    );
                  });
          }),
          const SizedBox(width: 8),
          _circleButton(Icons.phone, () => controller.makePhoneCall()),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20, color: Colors.black),
        ),
      ),
    );
  }

  // ========================================================================
  // PAYMENT (نفس تصميم المستخدم بدون زرار Retry)
  // ========================================================================

  Widget _paymentSection(BuildContext context, dynamic order) {
    final paymentStatus = order.paymentStatus.toString().toLowerCase();

    final isFailed = paymentStatus == "failed" || paymentStatus == "unpaid";
    final isPaid = paymentStatus == "paid";
    final isPending = paymentStatus == "pending";

    final Color color = isPaid
        ? Colors.green
        : isFailed
        ? Colors.red
        : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFailed
              ? Colors.red.withAlpha(50)
              : Colors.grey.withAlpha(40),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPaid
                  ? Icons.check
                  : isFailed
                  ? Icons.error_outline
                  : Icons.payment,
              color: color,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payment",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),

                const SizedBox(height: 3),

                Text(
                  isPaid
                      ? "Payment successful"
                      : isFailed
                      ? "Payment failed"
                      : isPending
                      ? "Payment is pending"
                      : "Payment not completed",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Text(
            order.paymentMethod.toString(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
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
