import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/orderdetailescontroller.dart';
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
        child: Appbarbackicon(
          herotag: '',
          title: "${controller.order?.orderNumber}",
        ),
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
          controller.Getcolorandstause(order.status);
          final color = controller.statusColor;
          final textstatus = controller.statusText;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. قسم معلومات الطلب الأساسية (الحالة والتاريخ)
                buildStatusSection(order.status, color!, textstatus!),

                const SizedBox(height: 15),

                // 2. قسم عنوان التوصيل والمعلومات الشخصية
                _buildAddressCard(
                  address: order.shippingAddress.name ?? "غير محدد",
                  status: order.status,
                  addresscity: order.shippingAddress.city ?? "غير محدد",
                  addressstreet: order.shippingAddress.street ?? "غير محدد",
                  order: order,
                  phone: order.shippingAddress.phone ?? "غير محدد",
                  username: order.username,
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
                  itemCount: controller.order!.items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = controller.order!.items[index];

                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Container(alignment: Alignment.center,
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("${item.productId}"),
                        ),
                        title: Text(
                          "${item.productName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("quantity: ${item.quantity}"),
                        trailing: Text(
                          "${item.price} \$", // تنسيق السعر
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
                _buildPriceSummary(
                  "${order.totalAmount}",
                  "${order.subtotal}",
                  "${order.shippingFee}",
                  "${order.taxAmount}",
                ),

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
  Widget buildStatusSection(String status, Color color, String textstatus) {
    int currentStep = _getStepIndex(status);

    final steps = [
      {"icon": Icons.receipt_long_rounded, "label": "قيد الانتظار"},
      {"icon": Icons.inventory_2_rounded, "label": "processing"},
      {"icon": Icons.local_shipping_rounded, "label": "shipped"},
      {"icon": Icons.check_circle_rounded, "label": "delivered"},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- العنوان + الحالة الحالية ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color.fromARGB(255, 11, 151, 231),
                    ),
                    SizedBox(width: 8),

                    Text(
                      "Status".tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                textstatus.tr,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- Horizontal Timeline ---
          Row(
            children: List.generate(steps.length, (index) {
              bool isActive = index <= currentStep;
              bool isLast = index == steps.length - 1;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        // الخط الشمال
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index == 0
                                ? Colors.transparent
                                : (index <= currentStep
                                      ? color
                                      : Colors.grey.shade300),
                          ),
                        ),

                        // الدائرة
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isActive ? color : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            steps[index]["icon"] as IconData,
                            size: 14,
                            color: isActive ? Colors.white : Colors.grey,
                          ),
                        ),

                        // الخط اليمين
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isLast
                                ? Colors.transparent
                                : (index < currentStep
                                      ? color
                                      : Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // النص
                    Text(
                      steps[index]["label"].toString().tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w400,
                        color: isActive ? color : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // تحويل الحالة
  int _getStepIndex(String status) {
    switch (status) {
      case "pending":
        return 0;
      case "processing":
        return 1;
      case "shipped":
        return 2;
      case "delivered":
        return 3;
      case "cancelled":
        return -1;
      default:
        return 0;
    }
  }

  // ودجت لعنوان التوصيل
  Widget _buildAddressCard({
    required String address,
    required String addresscity,
    required String addressstreet,
    required String phone,
    required String status,
    required String username,
    required order,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person_outline,
                  color: const Color.fromARGB(255, 11, 151, 231),
                ),
                SizedBox(width: 8),
                Text(
                  "Customer Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Text(
            "name:$username",
            style: TextStyle(
              color: const Color.fromARGB(255, 13, 95, 2),
              height: 1.5,
              fontSize: 15,
            ),
          ),
          Text(
            "phone:$phone",
            style: TextStyle(
              color: const Color.fromARGB(255, 16, 17, 16),
              height: 1.5,
              fontSize: 15,
            ),
          ),
          const Divider(height: 25),

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

              // status == '3'
              //     ? ElevatedButton.icon(
              //         onPressed: () {
              //           Get.to(Trakinginuserapp(), arguments: {"order": order});

              //           print(
              //             "Tracking order...==============================",
              //           );
              //         },
              //         icon: Icon(Icons.location_searching),
              //         label: Text("Trake"),
              //       )
              //     : SizedBox.shrink(),
            ],
          ),

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
  Widget _buildPriceSummary(
    String total,
    String subtotal,
    String shippingfee,
    String taxAmount,
  ) {
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
          samarycard("shopingfee", shippingfee),
          samarycard("taxAmount", taxAmount),

          samarycard("Subtotal", subtotal),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total price".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "$total \$",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 81, 230, 83),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget samarycard(String title, String total) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
      Text(
        "$total\$",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 81, 230, 83),
        ),
      ),
    ],
  );
}
