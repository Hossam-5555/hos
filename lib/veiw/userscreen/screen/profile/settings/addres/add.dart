import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';

class AddNewAddres extends StatelessWidget {
  const AddNewAddres({super.key});

  @override
  Widget build(BuildContext context) {
    AddressController controller = Get.put(AddressController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Add Address"),
      ),
      body: Column(
        children: [
          // الجزء العلوي (الخريطة أو Placeholder)
          Expanded(
            flex: 1,
            child: Center(child: Text("هنا القاهره")),
            //  Container(
            //   color: Colors.grey[300],
            //   child: Center(
            //     child: GoogleMap(
            //       mapType: MapType.normal,
            //       initialCameraPosition: CameraPosition(
            //         target: LatLng(
            //           controller.selectedLat.value,
            //           controller.selectedLng.value,
            //         ),
            //         zoom: 14,
            //       ),
            //       onTap: (position) {
            //         controller.addmarker(position);
            //       },
            //       markers: controller.marker.toSet(),
            //     ),
            //   ),
            // ),
          ),

          // الجزء السفلي (فورم التفاصيل)
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Textfealdauth(
                      label: 'name',
                      obscureText: false,
                      suffixIcon: Icons.send,
                      hint: 'Enter  name of location',
                      textEditingController: controller.name!,
                      valid: (String? val) {
                        return null;
                      },
                    ),
                    Textfealdauth(
                      label: 'city',
                      obscureText: false,
                      suffixIcon: Icons.location_city,
                      hint: 'Enter city name',
                      textEditingController: controller.city!,
                      valid: (String? val) {
                        return null;
                      },
                    ),
                    Textfealdauth(
                      label: 'sreet',
                      obscureText: false,
                      suffixIcon: Icons.streetview,
                      hint: 'Enter street name',
                      textEditingController: controller.street!,
                      valid: (String? val) {
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.addaddres();
                      },
                      child: const Text("حفظ العنوان"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
