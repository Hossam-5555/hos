import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/controler/admincontroller/order/ordertrackingcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
// import 'package:hos/core/functions/getpolyline.dart';

class Trackinscreenadmin extends StatelessWidget {
  const Trackinscreenadmin({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Trackingorderadmin());
    return Scaffold(
      body: GetBuilder<Trackingorderadmin>(
        builder: (controller) => HandlingDataView(
          statusrequest: controller.statusrequest,
          widget: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // Expanded(
              //   child: Container(
              //     height: 40,
              //     width: 60,
              //     alignment: AlignmentDirectional.center,
              //     decoration: BoxDecoration(
              //       color: Colors.orange,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: GoogleMap(
              //       polylines: controller.polylines,
              //       mapType: MapType.normal,
              //       markers: controller.marker.toSet(),
              //       initialCameraPosition: controller.cameraPosition!,
              //       onMapCreated: (GoogleMapController controllermap) {
              //         controller.completercontroller.complete(controllermap);
              //       },
              //     ),
              //   ),
              // ),
              Center(
                child: Container(
                  height: 40,
                  width: 60,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    child: Text("data"),
                    onPressed: () {
                      controller.getcurrentlocation();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
