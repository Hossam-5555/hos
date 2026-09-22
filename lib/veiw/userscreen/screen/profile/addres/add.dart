import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/Address/addandedit.dart';

// ignore: must_be_immutable
class AddNewAddres extends StatelessWidget {
  AddNewAddres({super.key});

  AddressController c = Get.put(AddressController());
  @override
  Widget build(BuildContext context) {
    // 1. استخدام Get.put كما أنت تفعل
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: GetBuilder<AddressController>(
        builder: (controller) => Addresspage<AddressController>(
          phone: controller.phone,
          onChangedtype: controller.onLocationTypeChanged,
          locationTypes: controller.locationTypes,
          selectedLocationType: controller.selectedLocationType,
          controller: controller,
          details: controller.street, // تم تمرير حقل الشارع الصحيح
          statusrequest: controller.statusrequest ?? Statusrequest.none,
          onTap: () {
            controller.addaddres(context);
          },

          size: size,
          selectedGovernorate: controller.selectedGovernorate,
          selectedCity: controller.selectedCity,

          onChanged: controller.onGovernorateChanged,
          onChangedcity: controller.onCityChanged,
          map: controller.map,
          currentlocation: controller.getcurrentlocation,
          // إضافة هذا السطر لتمرير onChangedcity
        ),
      ),
    );
  }
}
