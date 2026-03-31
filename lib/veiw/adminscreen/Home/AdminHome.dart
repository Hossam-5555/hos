import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/viewitem.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminorderscrean.dart';
import 'package:hos/veiw/wedget/admindrawer.dart';

// ignore: must_be_immutable
class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      drawer: Align(
        alignment:
            Alignment.topLeft, // هذا السطر يجبر الـ Drawer يبدأ من سقف الشاشة
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.2, // الطول المطلوب
          child: ClipRRect(
            // قمنا بتدوير الزاويتين السفليتين فقط ليكون الشكل منسدلاً من الأعلى
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            // تأكد أن AdminDrawer لا يحتوي على Scaffold داخلي يملأ الطول
            child: AdminDrawer(),
          ),
        ),
      ),
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
              onTap: () => Get.to(() => ViewCategories()),
            ),
            _buildDashboardCard(
              color: Colors.green,
              icon: Icons.shopping_bag_outlined,
              title: "المنتجات",
              onTap: () => Get.to(() => viewitem()),
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
                Get.to(() => OrderScreen());
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
                  color: Colors.grey.withAlpha(38),
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
                  backgroundColor: color.withAlpha(38),
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

// ================= Dashboard =================

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: const [
              Header(),
              SizedBox(height: 16),
              SearchBarWidget(),
              SizedBox(height: 20),
              StatsSection(),
              SizedBox(height: 20),
              SalesChart(),
              SizedBox(height: 20),
              RecentOrders(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= Header =================

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
        ),
        const SizedBox(width: 10),
        const Text(
          "Hello, Admin",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}

// ================= Search =================

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search orders, products...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ================= Stats =================

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: StatCard(
                title: "Total Sales",
                value: "\$128,500",
                growth: "+8.5%",
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: "Total Orders",
                value: "3,420",
                growth: "+12%",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: StatCard(title: "Products", value: "450 Active"),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: "Customers",
                value: "21,800",
                growth: "+5%",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ================= Stat Card =================

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? growth;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.growth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (growth != null)
            Text(growth!, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}

// ================= Chart =================

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sales Overview",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Chip(label: Text("Day")),
              SizedBox(width: 5),
              Chip(label: Text("Week")),
              SizedBox(width: 5),
              Chip(label: Text("Month")),
              SizedBox(width: 5),
              Chip(label: Text("Year")),
            ],
          ),
          const Expanded(child: Center(child: Text("Chart Here"))),
        ],
      ),
    );
  }
}

// ================= Orders =================

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Recent Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text("View All")),
          ],
        ),
        const OrderItem(
          name: "Sarah Johnson",
          status: "Fulfilled",
          color: Colors.green,
        ),
        const OrderItem(
          name: "Mike Williams",
          status: "Pending",
          color: Colors.orange,
        ),
        const OrderItem(
          name: "Emily Davis",
          status: "Cancelled",
          color: Colors.red,
        ),
      ],
    );
  }
}

// ================= Order Item =================

class OrderItem extends StatelessWidget {
  final String name;
  final String status;
  final Color color;

  const OrderItem({
    super.key,
    required this.name,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text("Order - $name"),
      subtitle: const Text("Nov 15"),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(status, style: TextStyle(color: color)),
      ),
    );
  }
}

// ================= Bottom Nav =================

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, color: Colors.black),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, color: Colors.black),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory, color: Colors.black),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: Colors.black),
          label: "",
        ),
      ],
    );
  }
}
