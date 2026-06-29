import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/data/model/Addresmodel.dart';
import 'package:hos/veiw/userscreen/screen/profile/profile.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/editaddress.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class ViewMyAddres extends StatelessWidget {
  ViewMyAddres({super.key});

  // من الأفضل استخدام Get.find() إذا كان الكنترولر قد تم حقنه مسبقاً،
  // ولكن سنترك Get.put() كما هي لضمان عدم حدوث تغيير في الهيكل الحالي لديك.
  final AddressController controller = Get.put(AddressController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "My Addresses"),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () => Get.toNamed(Approute.addnewaddres),
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.green),
        label: const Text("Add Address", style: TextStyle(color: Colors.white)),
      ),

      body: GetBuilder<AddressController>(
        builder: (controller) {
          // تأمين حالة الـ null في البداية لتفادي أي استدعاء عشوائي قبل اكتمال الطلب
          if (controller.statusrequest == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: AnimatedList(
              // 1️⃣ هذا هو الرابط السحري الذي كان ينقص الكود ليربط الواجهة بالـ Controller
              key: controller.Addressket,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              initialItemCount: controller.listaddresdata.length,
              itemBuilder: (context, index, animation) {
                // 2️⃣ تأمين إضافي للتأكد من أن الـ index لا يتخطى حجم المصفوفة الفعلي أثناء الحركات السريعة
                if (index >= controller.listaddresdata.length) {
                  return const SizedBox.shrink();
                }

                final address = controller.listaddresdata[index];

                return ScaleTransition(
                  scale: animation,
                  child: _card(
                    address,
                    () {
                      // تأكيد تمرير الـ id بشكل آمن من الموديل
                      if (address.id != null) {
                        controller.deleteAddres(address.id!);
                      }
                    },
                    context,
                    controller,
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

/// 📦 UI Card محسّن
Widget _card(
  AddresModel address,
  VoidCallback onDelete,
  BuildContext context,
  AddressController c,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: context.isDarkMode
          ? AppGradients.darkTitanium
          : AppGradients.lightPlatinum,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.grey.shade300,
        width: 1.5,
      ), // تخفيف لون الإطار
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            0.03,
          ), // ظل ناعم جداً يعطي عمق 3D بسيط
          blurRadius: 12,
          spreadRadius: 2,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Appcolor.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // جعل زوايا الأيقونة متناسقة مع الكارد
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: Appcolor
                        .primaryColor, // يفضل توحيد لون الأيقونة مع لون التطبيق الأساسي
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${address.name} \n ${address.city}, ${address.street}",
                  style: TextStyle(
                    fontWeight: FontWeight.w800, // خط أسمك قليلاً للعنوان
                    fontSize: 16,
                    color: context.isDarkMode
                        ? Colors.white
                        : Colors.black, // لون داكن للعنوا
                  ),
                ),
              ],
            ),
            // تصميم جديد لزر الحذف: أكثر أناقة وأقل إزعاجاً للعين
            PopupMenuButton<String>(
              // 1️⃣ تحسين شكل الزر نفسه
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.more_vert, color: Colors.black87),
              ),

              // 2️⃣ تحسين شكل القائمة المنسدلة
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              offset: const Offset(
                0,
                45,
              ), // إزاحة القائمة للأسفل قليلاً لتبدو منفصلة

              onSelected: (value) {
                // يمكنك تنفيذ المنطق هنا أيضاً إذا أردت
              },

              itemBuilder: (BuildContext context) => [
                // خيار التعديل
                PopupMenuItem(
                  onTap: () {
                    // تأكد من أن الـ id موجود قبل التمرير
                    if (address.id != null) {
                      Get.to(()=>EditAddressPage(),arguments:{
                        "AddresModel":address
                      } );
                    }
                  },
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "تعديل",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // خيار الحذف
                PopupMenuItem(
                  onTap: onDelete,
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "حذف",
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // ---------------- خط فاصل ----------------

        // ---------------- الجزء السفلي: تفاصيل العنوان ----------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  _addressDetailRow(
                    "City",
                    address.phone ??
                        'No phone provided', // استبدل هذا بالمتغير المناسب إذا كان لديك رقم الهاتف
                    Icons.phone,
                  ),
                  const SizedBox(height: 6),
                  _addressDetailRow(
                    "",
                    'set Default',
                    Icons.location_on,
                    widget: Switch.adaptive(
                      activeColor: Colors.green,
                      value: c.isdefault == address.id ? true : false,
                      onChanged: (bool value) {},
                    ),
                  ), // استبدله بمتغير الهاتف إذا وجد
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ---------------- ويدجت مساعدة لتنسيق النصوص بشكل احترافي ----------------
// ضع هذه الويدجت خارج أو داخل الكلاس (يفضل خارجها أو كـ Method مستقلة)
Widget _addressDetailRow(
  String label,
  String value,
  IconData icon, {
  Widget? widget,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Appcolor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.grey, size: 22),
            ),
          ),
          SizedBox(width: 8),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      widget ?? const SizedBox.shrink(),
    ],
  );
}
