import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';

import 'package:hos/veiw/userscreen/screen/profile/order/paymentmethods.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/viewaddres.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key}) {
    // initProfileControllers(); // 🔥 مهم جدًا
  }
  Myservisec myservisec = Get.find();



  @override
  Widget build(BuildContext context) {
    // Get.put(Profilepagecontroller());

    // متغيرات لتسهيل التعامل مع الأبعاد
    double screenHeight = Get.height;
    double screenWidth = Get.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.05), // مسافة علوية نسبية
          // ================== قسم البروفايل العلوي ==================
          Container(
            height: screenHeight * 0.20, // الارتفاع 22% من الشاشة
            width: screenWidth,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                // الكارت الأبيض الخلفي
                Container(
                  height: screenHeight * 0.17,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // محاذاة العناصر للأسفل
                    children: [
                      // بيانات المستخدم
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FittedBox(
                              // لضمان عدم خروج النص عن المساحة
                              child: Text(
                                "${myservisec.sharedPreferences.getString("usersname")}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18, // حجم خط متناسب
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            FittedBox(
                              child: Text(
                                "${myservisec.sharedPreferences.getString("email")}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10), // مسافة سفلية بسيطة
                          ],
                        ),
                      ),

                      // زر التعديل
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            iconColor: const Color.fromARGB(255, 26, 21, 9),
                            backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          ),
                          label: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.edit, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                // الصورة الشخصية
                Positioned(
                  right: 20, // تحديد مكان الصورة بدقة
                  top: 0,
                  child: CircleAvatar(
                    radius: screenWidth * 0.11, // نصف القطر نسبة من عرض الشاشة
                    backgroundColor: Colors.white, // إطار أبيض حول الصورة
                    child: CircleAvatar(
                      onBackgroundImageError: (exception, stackTrace) => Icon(
                        Icons.person_pin,
                        color: const Color.fromARGB(255, 163, 157, 157),
                      ),
                      radius: screenWidth * 0.10,
                      backgroundImage: AssetImage(Imageasset.twetter),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.03),

          // ================== قسم الكروت (Orders, Wishlist) ==================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                // استخدمنا Expanded ليأخذ كل كارت مساحة متساوية
                Expanded(
                  child: cardOrder(
                    Icons.card_giftcard,
                    "Orders",
                    () {
                      Get.toNamed(Approute.Orders);
                    },
                    // Get.find<Ordercontroller>().orderscount.value,
                  ),
                ),
                Expanded(
                  child: cardOrder(
                    Icons.favorite,
                    "Wishlist",
                    () {
                      Get.toNamed(Approute.myfavorite);
                    },
                    // Get.find<Myfavcontroler>().datacount.value,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // ================== القائمة السفلية ==================
          _buildOptionTile(Icons.location_on, "العناوين", () {
            Get.to(
              () => ViewMyAddres(),
              duration: Duration(milliseconds: 400),
              transition: Transition.fadeIn,
            );
          }),

          _buildOptionTile(Icons.credit_card, "طرق الدفع", () {
            Get.to(
              () => PaymentScreen(),
              duration: Duration(milliseconds: 400),
              transition: Transition.fadeIn,
            );
          }),

          _buildOptionTile(Icons.settings_outlined, "Settings", () {
            Get.to(
              () => Settings(),
              duration: Duration(milliseconds: 400),
              transition: Transition.fadeIn,
            );
          }),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // ودجت العناصر السفلية
  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blueAccent),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // ودجت الكروت العلوية
  Widget cardOrder(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100, // يمكن تثبيت الارتفاع هنا للشكل الجمالي
        margin: const EdgeInsets.symmetric(
          horizontal: 6,
        ), // قللنا المسافات الجانبية
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 5),
            FittedBox(
              // لضمان ظهور النص بالكامل في الشاشات الصغيرة
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
