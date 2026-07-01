import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hos/core/conistant/locationdata.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

// ignore: must_be_immutable
class Addresspage<T extends GetxController> extends StatelessWidget {
  final T controller;
  TextEditingController? name;
  TextEditingController? details;
  String? selectedGovernorate;
  String? selectedCity;
  Statusrequest statusrequest;
  void Function() onTap;
  Size size;
  Addresspage({
    super.key,
    required this.controller,
    required this.name,
    required this.details,
    this.selectedGovernorate,
    this.selectedCity,
    required this.statusrequest,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    final dynamic ctrl = controller;
    return Stack(
      children: [
        // 1. الجزء العلوي: الخريطة تملأ الجزء المتاح خلف الكارت
        SizedBox(
          height: size.height * 0.55,
          child: const Center(child: Text('Google Map Here')),
        ),

        // 2. زر تعديل الموقع (مع حماية خاصة من الأعلى)
        Positioned(
          top: 16,
          right: 16,
          child: SafeArea(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed: () => Get.snackbar(
                'تعديل الموقع',
                'اضغط على الخريطة لتغيير الموقع',
              ),
              child: const Text('تعديل الموقع على الخريطة'),
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
                          value: ctrl.selectedLocationType, // القيمة المختارة
                          items:
                              (ctrl.locationTypes
                                      as List<
                                        String
                                      >) // تأكد من تحويلها لقائمة نصوص
                                  .map(
                                    (String type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(), // **هذا هو الجزء الأهم: يجب أن ينتهي بـ .toList()**
                          onChanged: (val) {
                            ctrl.selectedLocationType = val;
                            ctrl.update();
                          },
                        ),

                        const SizedBox(height: 12),

                        // 2. المحافظة والمركز في Row
                        Row(
                          children: [
                            Expanded(
                              child: DropdownSearch<String>(
                                items: (f, cs) =>
                                    EgyptLocations.governorates.keys.toList(),
                                selectedItem: ctrl.selectedGovernorate,
                                onChanged: ctrl.onGovernorateChanged,
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
                                items: (f, cs) =>
                                    ctrl.selectedGovernorate == null
                                    ? []
                                    : (EgyptLocations.governorates[ctrl
                                              .selectedGovernorate] ??
                                          []),
                                selectedItem: ctrl.selectedCity,
                                onChanged: ctrl.onCityChanged,
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
                          ctrl.street,
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
