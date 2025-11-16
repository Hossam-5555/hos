import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/Homecontroller.dart';
import 'package:hos/veiw/wedget/admindrawer.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(adminHomecontroller());
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      drawer:AdminDrawer(),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: height * 0.08, // ارتفاع نسبي
        title: const Text(
          "لوحة تحكم المدير",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(width * 0.04), // Padding نسبي
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: height * 0.02,
          crossAxisSpacing: width * 0.04,
          childAspectRatio: width / (height * 0.35), // نسبي للعرض والارتفاع
          children: [
            _buildDashboardCard(
              color: Colors.blueAccent,
              icon: Icons.category_outlined,
              title: "الفئات",
              onTap: () => controller.gotocategories(),
            ),
            _buildDashboardCard(
              color: Colors.green,
              icon: Icons.shopping_bag_outlined,
              title: "المنتجات",
              onTap: () => controller.gotoitemsview(),
            ),
            _buildDashboardCard(
              color: Colors.orange,
              icon: Icons.analytics_outlined,
              title: "التقارير",
              onTap: () {},
            ),
            _buildDashboardCard(
              color: const Color.fromARGB(255, 82, 255, 203),
              icon: Icons.shopping_cart_outlined,
              title: " الطلبات",
              onTap: () {
                
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

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
                  radius: width * 0.18, // نسبي للعرض
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color, size: width * 0.12),
                ),
                SizedBox(height: height * 0.08),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.045, // حجم نص نسبي
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
