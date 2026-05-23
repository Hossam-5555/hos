import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/orderdetailscontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/order/detailsorder.dart';

class AdminOrderdetails extends StatelessWidget {
  const AdminOrderdetails({super.key});

  @override
  Widget build(BuildContext context) {
    // عمل Injection للـ Controller في بداية الشاشة
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

      // جزء عرض البيانات الأساسية للطلب
      body: GetBuilder<AdminOrderDetailesController>(
        builder: (_) {
          final o = controller.order;
          if (o == null) return const Center(child: Text("No Data"));

          // تحديث الألوان والنصوص بناءً على الحالة الحالية للطلب
          controller.getcolorandstause(o.status);

          return ListView(
            padding: EdgeInsets.all(w * 0.04),
            children: [
              statusorder(
                controller.currentStatus,
                controller.statusColor!,
                controller.statusText!,
              ),
              card(info(o)),
              card(items(o)),
              card(price(o)),

              // مسافة أمان إضافية لضمان عدم اختفاء آخر كارت خلف الزر السفلي عند عمل سكرول
              const SizedBox(height: 80),
            ],
          );
        },
      ),

      // الزر السفلي الثابت المخصص للـ Admin لتحديث الحالة في أي وقت
      bottomNavigationBar: GetBuilder<AdminOrderDetailesController>(
        builder: (_) {
          final o = controller.order;
          if (o == null) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.only(
              left: w * 0.04,
              right: w * 0.04,
              top: 12,
              bottom:
                  MediaQuery.of(context).padding.bottom +
                  12, // لتجنب حواف الـ Safe Area في بعض الأجهزة
            ),

            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                // يأخذ لون الحالة الحالية ليعطي انطباعاً متناسقاً بصرياً
                backgroundColor:
                    controller.statusColor ?? Theme.of(context).primaryColor,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // فتح قائمة الحالات عند الضغط على الزر
                _showStatusBottomSheet(context, controller);
              },
              icon: Icon(Icons.edit_note, color: Colors.white, size: 24),
              label: Text(
                controller.currentStatus == 'delivered' ||
                        controller.currentStatus == 'cancelled'
                    ? "لا يمكن التعديل علي حاله الطلب"
                    : "change status order",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo', // أو خط تطبيقك المعتمد
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة مخصصة لبناء الـ Bottom Sheet وعرض خيارات تعديل الحالات
  void _showStatusBottomSheet(
    BuildContext context,
    AdminOrderDetailesController controller,
  ) {
    final currentStatus = controller.currentStatus;

    // إذا كان الطلب منتهياً (تم التوصيل أو ملغي)، لا تفتح القائمة أصلاً
    if (currentStatus == 'delivered' || currentStatus == 'cancelled') {
      Get.snackbar("تنبيه", "هذا الطلب منتهي ولا يمكن تعديل حالته.");
      return;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "الإجراءات المتاحة للطلب الآن",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 10),

            // عرض الخيارات ديناميكياً بناءً على الحالة الحالية للطلب
            if (currentStatus == 'pending') ...[
              _buildStatusTile(
                "قبول وتجهيز الطلب",
                Colors.blue,
                () => controller.updateStatus('processing'),
              ),
              _buildStatusTile(
                "إلغاء الطلب",
                Colors.red,
                () => controller.updateStatus('cancelled'),
              ),
            ],

            if (currentStatus == 'processing') ...[
              _buildStatusTile(
                "تسليم للمندوب (شحن)",
                Colors.purple,
                () => controller.updateStatus('shipped'),
              ),
              _buildStatusTile(
                "إلغاء الطلب",
                Colors.red,
                () => controller.updateStatus('cancelled'),
              ),
            ],

            if (currentStatus == 'shipped') ...[
              _buildStatusTile(
                "تم توصيل الطلب بنجاح",
                Colors.green,
                () => controller.updateStatus('delivered'),
              ),
              // _buildStatusTile(
              //   "فشل التوصيل (مرتجع)",
              //   Colors.orange,
              //   () => controller.updateStatus('5'),
              // ), // إذا كان عندك حالة للمرتجع
            ],
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  // ودجت فرعية لبناء عناصر قائمة الحالات بشكل نظيف وعملي
  Widget _buildStatusTile(String title, Color color, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: CircleAvatar(radius: 7, backgroundColor: color),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Get.back(); // إغلاق القائمة أولاً
        onTap(); // تنفيذ دالة التحديث وإرسال البيانات للـ Server
      },
    );
  }
}

// Google Map
// SizedBox(
//   height: 200,
//   child: Text("Google map disabled for demo purposes"),
//   //  GoogleMap(
//   //   initialCameraPosition: CameraPosition(
//   //     target: location,
//   //     zoom: 14.0,
//   //   ),
//   //   markers: {
//   //     Marker(
//   //       markerId: MarkerId('deliveryLocation'),
//   //       position: location,
//   //       infoWindow: InfoWindow(title: "موقع التوصيل"),
//   //     ),
//   //   },
//   //   zoomControlsEnabled: false,
//   //   myLocationEnabled: false,
//   //   onMapCreated: (GoogleMapController controller) {
//   //     // ممكن تتحكم بالخريطة هنا
//   //   },
//   // ),
// ),

// ودجت لعرض الحالة بشكل جميل
