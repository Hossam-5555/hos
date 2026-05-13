import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/orderdetailscontroller.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/order/detailsorder.dart';

class AdminOrderdetails extends StatelessWidget {
  const AdminOrderdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminOrderDetailesController());
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Order Details"),
      ),
      body: GetBuilder<AdminOrderDetailesController>(
        builder: (_) {
          final o = controller.order;
          if (o == null) return Center(child: Text("No Data"));

          controller.Getcolorandstause(o.status);

          return ListView(
            padding: EdgeInsets.all(w * 0.04),
            children: [
              statusorder(o.status, controller.statusColor!, controller.statusText!),
              card(info(o)),
              card(items(o)),
              card(price(o)),
            ],
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

