import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/orderdetailescontroller.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/TraKingorder_userapp.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Orderdetailes extends StatelessWidget {
  const Orderdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر
    final controller = Get.put(Orderdetailescontroller());

    return Scaffold(
      // backgroundColor: Colors.grey[100], // خلفية رمادية فاتحة لإبراز البطاقات
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Order Details"),
      ),
      body: GetBuilder<Orderdetailescontroller>(
        builder: (_) {
          final order = controller.order;

          if (order == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "❌ لم يتم استلام بيانات الطلب",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          controller.Getcolorandstause(order.ordersStatus!);
          final color = controller.statusColor;
          final textstatus = controller.statusText;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. قسم معلومات الطلب الأساسية (الحالة والتاريخ)
                _buildStatusSection(order.ordersStatus!, color!, textstatus!),

                const SizedBox(height: 15),

                // 2. قسم عنوان التوصيل والمعلومات الشخصية
                _buildAddressCard(
                  address: order.addresName ?? "غير محدد",
                  status: order.ordersStatus!,
                  addresscity: order.addresCity!,
                  addressstreet: order.addresStreet!,
                  order: order,
                  // يمكنك إضافة اسم العميل هنا إذا كان متوفراً في موديل الطلب العام
                  // customerName: order.userName,
                ),

                const SizedBox(height: 20),
                Text(
                  "product".tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 3. قائمة المنتجات (Items List)
                // بدلاً من تكرار العنوان، نعرض قائمة المنتجات فقط هنا
                ListView.separated(
                  shrinkWrap: true, // ضروري داخل SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // منع السكرول الداخلي
                  itemCount: controller.data.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = controller.data[index];
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            "${LinkApi.imageitems}/${item.itemsImage}",
                          ),
                        ),
                        title: Text(
                          "${item.itemsName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("الكمية: ${item.itemsCount}"),
                        trailing: Text(
                          "${item.itemsPrice} \$", // تنسيق السعر
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 4. ملخص الفاتورة (السعر الإجمالي)
                _buildPriceSummary(order.ordersTotalprice ?? "0"),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widgets مساعدة للتصميم ---

  // ودجت لعرض الحالة بشكل جميل
  // 1. ودجت عرض الحالة وشريط التقدم
  Widget _buildStatusSection(
    String status,
    Color statusColor,
    String statusText,
  ) {
    // تحويل رقم الحالة إلى integer
    // لو فشل التحويل أو كانت الحالة (أرشيف)، هنعتبرها خارج نطاق التتبع العادي
    int currentStep = int.tryParse(status) ?? -1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- الجزء العلوي: العنوان وبادج الحالة الحالية ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status".tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  statusText.tr,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          
          // --- الجزء السفلي: شريط التقدم (يظهر فقط للحالات من 0 إلى 4) ---
          if (currentStep >= 0 && currentStep <= 4) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(height: 1, thickness: 0.5),
            ),
            _buildTimeline(currentStep),
          ]
        ],
      ),
    );
  }

  // 2. دالة بناء شريط التقدم بناءً على الـ 5 حالات
  Widget _buildTimeline(int currentStep) {
    // ربطنا كل رقم حالة بالأيقونة والاسم بتاعها من الكود بتاعك
    final List<Map<String, dynamic>> steps = [
      {"icon": Icons.receipt_long_rounded, "label": "قيد الانتظار"}, // 0
      {"icon": Icons.thumb_up_alt_rounded, "label": "تم التأكيد"},   // 1
      {"icon": Icons.inventory_2_rounded, "label": "يجهز"},         // 2
      {"icon": Icons.local_shipping_rounded, "label": "في الطريق"}, // 3
      {"icon": Icons.check_circle_rounded, "label": "مكتمل"},       // 4
    ];

    // نستخدم لون موحد (مثل الأخضر أو الأزرق) لتمثيل "الخطوات المكتملة" في الشريط
    const Color activeColor = Colors.green; 

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        bool isCompleted = index <= currentStep; // هل الخطوة دي خلصت أو إحنا فيها؟
        bool isLast = index == steps.length - 1; // هل دي آخر خطوة؟
        bool isFirst = index == 0; // هل دي أول خطوة؟

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  // الخط الأيسر (مخفي لأول خطوة عشان مفيش حاجة قبلها)
                  Expanded(
                    child: Container(
                      height: 3,
                      color: isFirst
                          ? Colors.transparent
                          : (isCompleted ? activeColor : Colors.grey.shade200),
                    ),
                  ),
                  
                  // الدائرة والأيقونة
                  Container(
                    padding: const EdgeInsets.all(6), // صغرنا البادينج عشان الـ 5 خطوات يكفوا
                    decoration: BoxDecoration(
                      color: isCompleted ? activeColor : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: isCompleted
                          ? Border.all(color: activeColor.withOpacity(0.3), width: 3)
                          : null,
                    ),
                    child: Icon(
                      steps[index]["icon"],
                      size: 16, // صغرنا الأيقونة شوية
                      color: isCompleted ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                  
                  // الخط الأيمن (مخفي لآخر خطوة عشان مفيش حاجة بعدها)
                  Expanded(
                    child: Container(
                      height: 3,
                      color: isLast
                          ? Colors.transparent
                          : (index < currentStep ? activeColor : Colors.grey.shade200),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // نص الخطوة
              Text(
                (steps[index]["label"] as String).tr, // لدعم الترجمة لو ضفتهم في ملفات اللغة
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10, // خط صغير مناسب لـ 5 عناصر جنب بعض
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
                  color: isCompleted ? Colors.black87 : Colors.grey.shade400,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ودجت لعنوان التوصيل
  Widget _buildAddressCard({
    required String address,
    required String addresscity,
    required String addressstreet,

    required String status,
    required order,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26), // 0.1 * 255 = 26
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color.fromARGB(255, 11, 151, 231),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              status == '3'
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Get.to(Trakinginuserapp(), arguments: {"order": order});

                        print(
                          "Tracking order...==============================",
                        );
                      },
                      icon: Icon(Icons.location_searching),
                      label: Text("Trake"),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          const Divider(height: 25),
          Text(
            "$address-$addresscity-$addressstreet",
            style: TextStyle(
              color: const Color.fromARGB(255, 13, 95, 2),
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ودجت لملخص السعر
  Widget _buildPriceSummary(String total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26), // 0.1 * 255 = 26
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total price".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "$total \$",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
