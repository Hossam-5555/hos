import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/orderdetailscontroller.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class DriverOrderdetails extends StatelessWidget {
  const DriverOrderdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverOrderDetailesController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Order Details"),
      ),
      body: GetBuilder<DriverOrderDetailesController>(
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
                  orderprice: '${controller.data[index].itemsPrice}',
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
  final String orderprice;
  final String customerName;
  final String address;
  final String status;
  // final LatLng location;

  const OrderDetailsCard({
    Key? key,
    required this.orderprice,
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
                "price : $orderprice",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("محتويات الطلب: $customerName"),
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