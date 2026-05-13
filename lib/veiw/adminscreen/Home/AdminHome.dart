import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/AdminHome.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

// ignore: must_be_immutable
class AdminHome2 extends StatelessWidget {
  AdminHome2({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final height = size.height;
    // final width = size.width;
    final c = Get.put(Adminhome());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Searchbar(
                title: 'Search orders, products...',
                mycontroller: c.searchcontroller,
              ),
              const SizedBox(height: 20),
              const StatsSection(),
              const SizedBox(height: 20),
              const SalesChart(),
              const SizedBox(height: 20),
              const RecentOrders(),
            ],
          ),
        ),
      ),
    );
  }
}

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
        // color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withAlpha(50),
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withAlpha(50),
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
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
