import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart'; 
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class ViewMyAddres extends StatelessWidget {
  const ViewMyAddres({super.key});

  @override
  Widget build(BuildContext context) {
    // تم التعديل لمنع التحذير (unused_local_variable)
    Get.put(AddressController());
    
    return Scaffold(
      // لون خلفية فاتح جداً ليبرز الكروت البيضاء
      backgroundColor: const Color(0xFFF9F9F9), 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "My Addresses"),
      ),
      
      // ✨ زر الإضافة العائم
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black, 
        elevation: 2, // إضافة ظل خفيف للزر
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () => Get.toNamed(Approute.addnewaddres),
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white, size: 20),
        label: const Text(
          "Add Address",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
      ),
      
      body: GetBuilder<AddressController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80), 
              itemCount: controller.listaddresdata.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14), 
              itemBuilder: (context, index) {
                final address = controller.listaddresdata[index];
                
                // 📦 الكارت الجديد بتصميم احترافي (بدون Dismissible)
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200), // إطار خفيف
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04), // ظل ناعم جداً
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // إضافة حدث عند الضغط على العنوان بالكامل
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            // 📍 أيقونة العنوان
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Appcolor.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.location_on_rounded, color: Appcolor.primaryColor, size: 26),
                            ),
                            const SizedBox(width: 16),
                            
                            // 📝 تفاصيل العنوان بتاخد باقي المساحة
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.addresName ?? "No Name",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${address.addresStreet ?? 'Tap to edit'}${address.addresCity != null ? ' - ${address.addresCity}' : ''}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      height: 1.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            
                            // 🗑️ زر الحذف الجديد
                            IconButton(
                              onPressed: () {
                                // 🛡️ رسالة تأكيد قبل الحذف لمنع الحذف بالخطأ
                                Get.defaultDialog(
                                  title: "Delete Address",
                                  titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                                  middleText: "Are you sure you want to delete this address?",
                                  radius: 12,
                                  textCancel: "Cancel",
                                  textConfirm: "Delete",
                                  cancelTextColor: Colors.black,
                                  confirmTextColor: Colors.white,
                                  buttonColor: Colors.redAccent,
                                  onConfirm: () {
                                    controller.deleteAddres(address.addresId.toString());
                                    Get.back(); // إغلاق الديالوج
                                    Get.snackbar(
                                      "Deleted",
                                      "Address has been removed successfully",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.black87,
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(12),
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                size: 26,
                              ),
                              tooltip: 'Delete Address',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}