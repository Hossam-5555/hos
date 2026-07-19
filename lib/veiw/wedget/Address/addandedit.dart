import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hos/core/conistant/locationdata.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:latlong2/latlong.dart';

// ignore: must_be_immutable
class Addresspage<T extends GetxController> extends StatelessWidget {
  final T controller;
  TextEditingController? details;
  String? selectedGovernorate;
  String? selectedCity;
  String? selectedLocationType; // (منزل، كافيه، إلخ)
  Statusrequest statusrequest;
  void Function() onTap;
  ValueChanged<String?>? onChanged;
  ValueChanged<String?>? onChangedcity;
  ValueChanged<String?>? onChangedtype;
  MapController map;
  List<String> locationTypes;
  Size size;
  Addresspage({
    super.key,
    required this.controller,
    required this.details,
    this.selectedGovernorate,
    this.selectedCity,
    required this.statusrequest,
    required this.onTap,
    required this.size,
    this.onChanged,
    this.onChangedcity,
    required this.selectedLocationType,
    required this.locationTypes,
    this.onChangedtype,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // 1. الجزء العلوي: الخريطة تملأ الجزء المتاح خلف الكارت
        FlutterMap(
          mapController: map,
          options: const MapOptions(
            initialRotation: 1,
            initialCenter: LatLng(0, 0),
            initialZoom: 10,
            minZoom: 0,
            maxZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.hos',
            ),
            CurrentLocationLayer(
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(
                  child: Icon(Icons.location_pin, color: Colors.white),
                ),
                markerSize: Size(35, 35),
                markerDirection: MarkerDirection.heading,
              ),
            ),
          ],
        ),

        // 2. زر تعديل الموقع (مع حماية خاصة من الأعلى)
        Positioned(
          top: 16,
          right: 16,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => Get.snackbar(
                'تعديل الموقع',
                'اضغط على الخريطة لتغيير الموقع',
              ),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Icon(Icons.gps_fixed),
              ),
            ),
          ),
        ),

        // 3. الجزء السفلي: الكارت الشفاف المطاطي الذكي
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                // يضمن ألا يتعدى الكارت 45% من الشاشة لترك مساحة كافية للخريطة
                constraints: BoxConstraints(maxHeight: size.height * 0.45),
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? const Color(0xFF232429).withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false, // يحمي المحتوى من شريط السحب السفلي للهاتف
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'نوع المكان',
                            prefixIcon: Icon(Icons.place),
                          ),
                          value: selectedLocationType, // القيمة المختارة
                          items:
                              (locationTypes) // تأكد من تحويلها لقائمة نصوص
                                  .map(
                                    (String type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(), // **هذا هو الجزء الأهم: يجب أن ينتهي بـ .toList()**
                          onChanged: onChangedtype,
                        ),

                        const SizedBox(height: 12),

                        // 2. المحافظة والمركز في Row
                        Row(
                          children: [
                            Expanded(
                              child: DropdownSearch<String>(
                                items: (f, cs) =>
                                    EgyptLocations.governorates.keys.toList(),
                                selectedItem: selectedGovernorate,
                                onChanged: onChanged,
                                decoratorProps: const DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    labelText: 'المحافظة',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownSearch<String>(
                                items: (f, cs) => selectedGovernorate == null
                                    ? []
                                    : (EgyptLocations
                                              .governorates[selectedGovernorate] ??
                                          []),
                                selectedItem: selectedCity,
                                onChanged: onChangedcity,
                                decoratorProps: const DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    labelText: 'المركز',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        _buildTextField(
                          details!,
                          'تفاصيل المكان',
                          Icons.location_on,
                        ),
                        const SizedBox(height: 16),
                        GetBuilder<T>(
                          builder: (controller) => Checkbutton(
                            statusrequest: statusrequest,
                            buttonColor: Colors.black,
                            width: size.width,
                            onTap: onTap,
                            buttonName: "Save location",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Textfealdauth(
        obscureText: false,
        suffixIcon: icon,
        hint: hint,
        textEditingController: controller,
        valid: (val) => null,
      ),
    );
  }
}
