import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/data/model/Addresmodel.dart';
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
/// 📦 UI Card محسّن بالتصميم الجديد
Widget _card(
  AddressModel address,
  VoidCallback onDelete,
  BuildContext context,
  AddressController c,
) {
  bool isdefalt = c.isdefault == address.id;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade300, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- القسم الأيسر: النصوص والأيقونات ----------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1️⃣ الشارات (Tags) - يمكنك استخدامها لإظهار ما إذا كان العنوان هو الأساسي
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (isdefalt)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'DEFAULT ADDRESS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 2️⃣ العنوان (Title) مع زر القائمة (Menu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "${address.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: context.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // زر الـ Menu القديم الخاص بك مدمج هنا بشكل أنيق
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                        size: 20,
                      ),
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            onTap: () {
                              if (address.id != null) {
                                Get.to(
                                  () => EditAddressPage(),
                                  arguments: {"AddresModel": address},
                                );
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
                          PopupMenuItem(
                            onTap: () {
                              if (address.id != null)
                                c.updatedefault(address.id!);
                            },
                            value: 'Set default',
                            child: Row(
                              children: [
                                Icon(
                                  isdefalt
                                      ? Icons.turned_in
                                      : Icons.turned_in_not_sharp,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Set default",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // 3️⃣ تفاصيل العنوان
              Text(
                "${address.city}, ${address.street}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // 4️⃣ رقم الهاتف
              Text(
                address.phone ?? 'No phone provided',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),

              // 5️⃣ الأيقونات السفلية (كما في التصميم)
              Row(
                children: [
                  _buildBottomIcon(Icons.location_on_outlined),
                  _buildBottomIcon(Icons.phone_outlined),
                  _buildBottomIcon(Icons.language),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ---------------- القسم الأيمن: الصورة ----------------
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            height: 140,
            width: 110,
            imageUrl:
                "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=2053&auto=format&fit=crop",
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline),
          ),
        ),
      ],
    ),
  );
}

// ---------------- ويدجت مساعدة للأيقونات السفلية ----------------
Widget _buildBottomIcon(IconData icon, {Color color = Colors.black54}) {
  return Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.grey.shade200, // لون خلفية الأيقونة
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 18, color: color),
  );
}
