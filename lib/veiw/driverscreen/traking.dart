import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/controler/drivercontroller/trakingcontroller.dart';
// import 'package:hos/core/functions/getpolyline.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Trakingindriverapp extends StatelessWidget {
  const Trakingindriverapp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(
          herotag: '',
          title: "Tracking",
        ),
      ),
      body: GetBuilder<Trakingdrivercontroller>(
        builder: (controller) => Stack(
          children: [
            /// =========================
            /// Google Map
            /// =========================
            // GoogleMap(
            //   polylines: controller.polylines,
            //   initialCameraPosition: controller.cameraPosition!,
            //   onMapCreated: (GoogleMapController controllerGoogleMap) {
            //     controller.completercontroller = controllerGoogleMap;
            //   },
            //   myLocationEnabled: true,
            //   myLocationButtonEnabled: true,
            //   zoomControlsEnabled: false,
            //   mapType: MapType.normal,
            //   markers: controller.marker.toSet(),
            // ),

            /// زر إنهاء التتبع
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // controller.endTracking();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "End Tracking",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
