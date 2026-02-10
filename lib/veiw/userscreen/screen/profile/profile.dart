import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/profilepagecontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
import 'package:hos/veiw/userscreen/screen/myfavorite.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orders.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/viewaddres.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Profilepagecontroller());

    // متغيرات لتسهيل التعامل مع الأبعاد
    double screenHeight = Get.height;
    double screenWidth = Get.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.05), // مسافة علوية نسبية
          // ================== قسم البروفايل العلوي ==================
          Container(
            height: screenHeight * 0.22, // الارتفاع 22% من الشاشة
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
                          children: const [
                            FittedBox(
                              // لضمان عدم خروج النص عن المساحة
                              child: Text(
                                "Hossam Yasser",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18, // حجم خط متناسب
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            FittedBox(
                              child: Text(
                                "hossam@email.com",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(height: 10), // مسافة سفلية بسيطة
                          ],
                        ),
                      ),

                      // زر التعديل
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          iconColor: const Color.fromARGB(255, 26, 21, 9),
                          backgroundColor: const Color.fromARGB(
                            255,
                            194,
                            180,
                            166,
                          ),
                        ),
                        label: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 16),
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
                  child: cardOrder(Icons.card_giftcard, "Orders", () {
                    Get.to(
                      () => Orders(),
                      duration: Duration(milliseconds: 400),
                      transition: Transition.fadeIn,
                    );
                  }),
                ),
                Expanded(
                  child: cardOrder(Icons.favorite, "Wishlist", () {
                    Get.to(
                      () => Myfavorite(),
                      duration: Duration(milliseconds: 400),
                      transition: Transition.fadeIn,
                    );
                  }),
                ),
                Expanded(
                  child: cardOrder(Icons.notifications, "Messages", () {
                    Get.to(
                      () => NotificationPage(),
                      duration: Duration(milliseconds: 400),
                      transition: Transition.fadeIn,
                    );
                  }),
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

          _buildOptionTile(Icons.credit_card, "طرق الدفع", () {}),

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
            color: const Color.fromARGB(255, 201, 181, 162).withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color.fromARGB(255, 114, 99, 84)),
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
            Icon(
              icon,
              color: const Color.fromARGB(255, 201, 181, 162),
              size: 28,
            ),
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
            const Text(
              "8",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
