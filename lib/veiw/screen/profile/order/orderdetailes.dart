import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/controler/profile/order/orderdetailescontroller.dart';

class Orderdetailes extends StatelessWidget {
  const Orderdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Orderdetailescontroller());

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
            height: 48,
            padding: EdgeInsets.only(left: 4),
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
      body: GetBuilder<Orderdetailescontroller>(
        builder: (_) {
          final order = controller.order;
          if (order == null) {
            return const Center(child: Text("❌ لم يتم استلام بيانات الطلب"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(controller.data.length, (index) {
                return OrderDetailsCard(
                  orderId: '${controller.data[index].itemsPrice}',
                  customerName: '${controller.data[index].itemsName}',
                  address: '${order.addresName}',
                  status: '${order.ordersStatus}',
                  // location: null,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class OrderDetailsCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String address;
  final String status;
  // final LatLng location;

  const OrderDetailsCard({
    Key? key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.status,
    // required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "رقم الطلب: $orderId",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("العميل: $customerName"),
              Text("العنوان: $address"),
              Text("الحالة: $status"),
            ],
          ),
        ),

        // Divider
        Divider(height: 10),

      
      ],
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