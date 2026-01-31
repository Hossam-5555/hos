import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/profilepagecontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/class/gotoanypage.dart';
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
    final gotoany = Get.put(Gotoanypagecalss());
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // صورة المستخدم + الاسم
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(Imageasset.see),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        " Hossam",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "hossam@email.com",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // قائمة الخيارات
          _buildOptionTile(Icons.shopping_bag, "طلباتي", () {
            gotoany.Gotoanypage(Orders(), false, {});
          }),
          _buildOptionTile(Icons.favorite_outline_outlined, "المفضله", () {
            gotoany.Gotoanypage(Myfavorite(), false, {});
          }),
          _buildOptionTile(Icons.location_on, "العناوين", () {
            gotoany.Gotoanypage(ViewMyAddres(), false, {});
          }),

          _buildOptionTile(Icons.credit_card, "طرق الدفع", () {}),

          _buildOptionTile(Icons.settings_outlined, "Settings", () {
            gotoany.Gotoanypage(Settings(), false, {});
          }),

          const SizedBox(height: 50),

          // زر تسجيل خروج
        ],
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
