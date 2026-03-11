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
    // ignore: unused_local_variable
    AddressController addressController = Get.put(AddressController());
    
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "My Addresses"),
      ),
      
      // ✨ زر الإضافة العائم
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black, 
        elevation: 0,
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
              separatorBuilder: (context, index) => const SizedBox(height: 12), 
              itemBuilder: (context, index) {
                final address = controller.listaddresdata[index];
                
                // 👈 هنا السحر: غلفنا الكارت بـ Dismissible
                return Dismissible(
                  key: Key(address.addresId.toString()), // لازم Key فريد لكل عنصر
                  direction: DismissDirection.endToStart, // السحب من اليمين للشمال
                  
                  // 🗑️ الخلفية الحمراء اللي بتظهر تحت الكارت وقت السحب
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 146, 3, 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.delete_sweep_rounded, // أيقونة شيك للحذف
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  
                  // ⚡ الأكشن اللي هيحصل لما السحب يكتمل
                  onDismissed: (direction) {
                    controller.deleteAddres(address.addresId.toString());
                    
                    // اختياري: إظهار رسالة للمستخدم إن العنوان اتمسح
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
                  
                  // 📦 الكارت نفسه (بقى أنظف بكتير بعد ما شيلنا زرار المسح)
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color.fromARGB(255, 119, 119, 119)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          // أكشن عند الضغط
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // 📍 أيقونة العنوان
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Appcolor.primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.location_on_rounded, color: Appcolor.primaryColor, size: 24),
                              ),
                              const SizedBox(width: 14),
                              
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
                                    const SizedBox(height: 4),
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
                            ],
                          ),
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