import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/editcontroller.dart';
import 'package:hos/veiw/wedget/Address/addandedit.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class EditAddressPage extends StatelessWidget {
  const EditAddressPage({super.key});
  @override
  Widget build(BuildContext context) {
    // ربط أو استدعاء الكنترولر الخاص بالتعديل
    Get.put(Editaddress());

    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // يضمن رفع الكارت تلقائياً عند فتح الكيبورد
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Edit Address"),
      ),
      body: GetBuilder<Editaddress>(
        builder: (controller) => Addresspage<Editaddress>(
          onChangedtype: controller.onLocationTypeChanged,
          locationTypes: controller.locationTypes,
          selectedLocationType: controller.selectedLocationType,
          controller: controller,
          details: controller.street, // تم تمرير حقل الشارع الصحيح
          statusrequest: controller.statusrequest,
          onTap: () {
            controller.updateaddres(controller.model!.id!.toString());
          },
          size: size,
          selectedGovernorate: controller.selectedGovernorate,
          selectedCity: controller.selectedCity,
          onChanged: controller.onGovernorateChanged,
          map: controller.mapController,
          onChangedcity:
              controller.onCityChanged, // إضافة هذا السطر لتمرير onChangedcity
        ),
      ),
    );
  }
}
