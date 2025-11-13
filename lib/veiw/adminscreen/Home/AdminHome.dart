import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/Homecontroller.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final Myservisec myservisec = Myservisec();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(adminHomecontroller());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "لوحة تحكم المدير",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, color: Colors.black87),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildDashboardCard(
              color: Colors.blueAccent,
              icon: Icons.category_outlined,
              title: "الفئات",
              onTap: () => controller.gotocategories(),
            ),
            _buildDashboardCard(
              color: Colors.green,
              icon: Icons.shopping_cart_outlined,
              title: "المنتجات",
              onTap: () {
                controller.gotoitemsview();
              },
            ),
            _buildDashboardCard(
              color: Colors.orange,
              icon: Icons.analytics_outlined,
              title: "التقارير",
              onTap: () {
                // صفحة التحليلات أو الإحصائيات
              },
            ),
            _buildDashboardCard(
              color: Colors.redAccent,
              icon: Icons.logout,
              title: "تسجيل الخروج",
              onTap: () {
                myservisec.sharedPreferences.clear();
                Get.offAllNamed(Approute.login);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required Color color,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
