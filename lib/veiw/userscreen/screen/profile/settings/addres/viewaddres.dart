import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/data/model/Addresmodel.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewMyAddres extends StatelessWidget {
  ViewMyAddres({super.key});

  final AddressController controller = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "My Addresses"),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () => Get.toNamed(Approute.addnewaddres),
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
        label: const Text("Add Address", style: TextStyle(color: Colors.white)),
      ),

      body: GetBuilder<AddressController>(
        builder: (_) {
          bool isenable = controller.statusrequest == Statusrequest.loading;
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: Skeletonizer(
              containersColor: Colors.grey.withAlpha(90),

              enabled: isenable,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: controller.listaddresdata.length,
                itemBuilder: (context, index) {
                  final address = controller.listaddresdata[index];

                  return _card(address, () {
                    controller.deleteAddres(address.id.toString());
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 📦 UI Card محسّن
Widget _card(AddresModel address, VoidCallback onDelete) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Appcolor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.location_on, color: Appcolor.primaryColor, size: 26),
      ),

      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${address.name}${"Addres"}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "${address.street ?? 'No Street'}${":Street"} - ${address.city ?? 'No City'}${":City"}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.3,
            ),
          ),
          Text(
            "phone-numper:01023426561",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ],
      ),

      trailing: IconButton(
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.redAccent,
          size: 26,
        ),
        onPressed: onDelete,
        tooltip: 'Delete Address',
      ),
    ),
  );
}
