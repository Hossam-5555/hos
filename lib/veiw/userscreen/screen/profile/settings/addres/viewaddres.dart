import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart'; // تأكد من استدعاء ملف الألوان
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class ViewMyAddres extends StatelessWidget {
  const ViewMyAddres({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    AddressController addressController = Get.put(AddressController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50], // خلفية هادئة تبرز البطاقات
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "My Addresses"),
      ),
      
      // ✨ زر الإضافة العائم بتصميم محسّن
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Appcolor.primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // حواف دائرية حديثة
        ),
        onPressed: () {
          Get.toNamed(Approute.addnewaddres);
        },
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: const Text(
          "Add Address",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
      ),
      
      body: GetBuilder<AddressController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: ListView.separated(
              physics: const BouncingScrollPhysics(),
              // مسافة سفلية 80 لكي لا يغطي زر الإضافة على آخر عنصر
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 80), 
              itemCount: controller.listaddresdata.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final address = controller.listaddresdata[index];
                
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                        // مكان جاهز مستقبلاً لو أردت إضافة وظيفة عند الضغط على العنوان
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 📍 أيقونة العنوان
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Appcolor.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: Appcolor.primaryColor,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // 📝 تفاصيل العنوان
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.addresName ?? "No Name",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  // قمت بإضافة تفاصيل الشارع والمدينة بناءً على الكود السابق (يمكنك مسحها إذا لم تكن موجودة في الموديل هنا)
                                  Text(
                                    "${address.addresStreet ?? 'Tap to edit'} ${address.addresCity != null ? '- ${address.addresCity}' : ''}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // 🗑️ زر الحذف
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  controller.deleteAddres(address.addresId.toString());
                                },
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                tooltip: "Delete Address",
                              ),
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