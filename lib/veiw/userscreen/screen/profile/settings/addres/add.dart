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

    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Add Address"),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      /// الجزء العلوي (الخريطة أو Placeholder)
                      Container(
                        height: size.height * 0.40,
                        margin: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),

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

                      /// الفورم
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),

                          child: Form(
                            child: Column(
                              children: [
                                Textfealdauth(
                                  obscureText: false,
                                  suffixIcon: Icons.send,
                                  hint: 'Enter name of location',
                                  textEditingController: controller.name!,
                                  valid: (String? val) {
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                Textfealdauth(
                                  obscureText: false,
                                  suffixIcon: Icons.location_city,
                                  hint: 'Enter city name',
                                  textEditingController: controller.city!,
                                  valid: (String? val) {
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                Textfealdauth(
                                  obscureText: false,
                                  suffixIcon: Icons.streetview,
                                  hint: 'Enter street name',
                                  textEditingController: controller.street!,
                                  valid: (String? val) {
                                    return null;
                                  },
                                ),

                                const Spacer(),

                                SizedBox(
                                  width: double.infinity,
                                  height: 55,

                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      controller.addaddres();
                                    },

                                    child: const Text(
                                      "Save location",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
