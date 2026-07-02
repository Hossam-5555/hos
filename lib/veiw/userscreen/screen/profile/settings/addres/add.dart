import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/Address/addandedit.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class AddNewAddres extends StatelessWidget {
  const AddNewAddres({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. استخدام Get.put كما أنت تفعل
    Get.put(AddressController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Add Address"),
      ),
      // 2. تمرير البيانات المطلوبة لـ Addresspage
      body: GetBuilder<AddressController>(
        builder: (controller) => Addresspage<AddressController>(
          onChangedtype: controller.onLocationTypeChanged,
          locationTypes: controller.locationTypes,
          selectedLocationType: controller.selectedLocationType,
          controller: controller,
          details: controller.street, // تم تمرير حقل الشارع الصحيح
          statusrequest: controller.statusrequest ?? Statusrequest.none,
          onTap: () {
            controller.addaddres();
          },
          size: size,
          selectedGovernorate: controller.selectedGovernorate,
          selectedCity: controller.selectedCity,

          onChanged: controller.onGovernorateChanged,
          onChangedcity:
              controller.onCityChanged, // إضافة هذا السطر لتمرير onChangedcity
        ),
      ),
    );
  }
}
