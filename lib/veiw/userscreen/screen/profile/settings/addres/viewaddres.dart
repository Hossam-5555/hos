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
                    controller.deleteAddres(address.id!);
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
    padding: const EdgeInsets.all(16), // إضافة مسافات داخلية مريحة
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- الجزء العلوي: العنوان وزرار الحذف ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Appcolor.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_on_rounded, // أيقونة شكلها أحدث
                    color: Appcolor.primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${address.name} Address", // تم تعديل شكل النص ليكون احترافي
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
                size: 24,
              ),
              onPressed: onDelete,
              tooltip: 'Delete Address',
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(), // عشان زرار الحذف مياخدش مساحة كبيرة
            ),
          ],
        ),

        // ---------------- خط فاصل ----------------
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
        ),

        // ---------------- الجزء السفلي: تفاصيل العنوان ----------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.map_outlined, color: Colors.grey.shade400, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Street: ${address.street ?? 'No Street'}", // ترتيب النص بشكل منطقي
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "City: ${address.city ?? 'No City'}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Phone: 01023426561", // لو عندك متغير للتليفون يفضل تحطه هنا بدل الرقم الثابت
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
