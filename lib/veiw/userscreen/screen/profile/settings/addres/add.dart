import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/veiw/wedget/Address/addandedit.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class AddNewAddres extends StatelessWidget {
  const AddNewAddres({super.key});

  @override
  Widget build(BuildContext context) {
    AddressController controller = Get.put(AddressController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true, // يضمن رفع العناصر عند ظهور الكيبورد
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Add Address"),
      ),
      body: Addresspage<AddressController>(
        city: controller.city,
        name: controller.name,
        statusrequest: controller.statusrequest!,
        onTap: () {
          controller.addaddres();
        },
        street: controller.street,
        controller: controller,
        size: size,
      ),
    );
  }
}
