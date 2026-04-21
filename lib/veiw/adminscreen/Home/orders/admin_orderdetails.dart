import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/orderdetailscontroller.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class AdminOrderdetails extends StatelessWidget {
  const AdminOrderdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminOrderDetailesController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Order Details"),
      ),
      body: GetBuilder<AdminOrderDetailesController>(
        builder: (_) {
          final order = controller.order;
          if (order == null) {
            return const Center(child: Text("❌ لم يتم استلام بيانات الطلب"));
          }
          controller.Getcolorandstause(order.status!);
          final statusColor = controller.statusColor;
          final statusText = controller.statusText;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. قسم معلومات الطلب الأساسية (الحالة والتاريخ)
                _buildStatusSection(order.status!, statusColor!, statusText!),

                const SizedBox(height: 15),

                // 2. قسم عنوان التوصيل والمعلومات الشخصية
                _buildAddressCard(
                  address: order.shippingAddress.name ?? "غير محدد",
                  status: order.status,
                  order: order,
                ),

                const SizedBox(height: 20),
                const Text(
                  "المنتجات",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // 3. قائمة المنتجات (Items List)
                // بدلاً من تكرار العنوان، نعرض قائمة المنتجات فقط هنا
                ListView.separated(
                  shrinkWrap: true, // ضروري داخل SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // منع السكرول الداخلي
                  itemCount: controller.data.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = controller.data[index];
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          "${item.itemsName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("الكمية: ${item.itemsCount}"),
                        trailing: Text(
                          "${item.itemsPrice} \$", // تنسيق السعر
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 4. ملخص الفاتورة (السعر الإجمالي)
                _buildPriceSummary(order.taxAmount),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
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
Widget _buildStatusSection(
  String status,
  Color statusColor,
  String statusText,
) {
  // تحديد لون الحالة بناءً على النص

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(26),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "حالة الطلب",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withAlpha(130)),
          ),
          child: Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

// ودجت لعنوان التوصيل
Widget _buildAddressCard({
  required String address,
  required String status,
  order,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(26),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ignore: avoid_unnecessary_containers
            Container(
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    "عنوان التوصيل",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            status == '3'
                ? ElevatedButton.icon(
                    onPressed: () {
                      // Get.to(Trakingindriverapp(), arguments: {"order": order});
                    },
                    icon: Icon(Icons.location_searching),
                    label: Text("Trake"),
                  )
                : SizedBox.shrink(),
          ],
        ),
        const Divider(height: 25),
        Text(
          address,
          style: TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 15),
        ),
      ],
    ),
  );
}

// ودجت لملخص السعر
Widget _buildPriceSummary(double total) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(26),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "الإجمالي الكلي",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "$total \$",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
