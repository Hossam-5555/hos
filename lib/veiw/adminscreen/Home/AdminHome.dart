import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/AdminHome.dart';

// ignore: must_be_immutable
class AdminHome2 extends StatelessWidget {
  AdminHome2({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Adminhome());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              StatsSection(c: c),
              const SizedBox(height: 20),
              SalesChart(c: c),
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
  StatsSection({super.key, required this.c});
  Adminhome c;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "Total Sales",
                value: "\$${c.apidata[0].totalSales}",
                growth: "+8.5%",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: "Total Orders",
                value: "${c.apidata[0].totalOrders}",
                growth: "+12%",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "Products",
                value: "${c.apidata[0].activeProducts} Active",
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: "Customers",
                value: "${c.apidata[0].customers}",
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
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withAlpha(50),
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (growth != null)
            Text(growth!, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}

class SalesChart extends StatelessWidget {
  SalesChart({super.key, required this.c});
  Adminhome c;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280, // زيادة الارتفاع قليلاً ليناسب الرسم البياني والمسميات
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        // تم التعديل من Row إلى Column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الجزء العلوي: العنوان وأزرار الفلترة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sales Overview",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterChip("Day", isSelected: true),
                    _buildFilterChip("Week"),
                    _buildFilterChip("Month"),
                    _buildFilterChip("Year"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // الجزء الخاص بالرسم البياني
          Expanded(child: LineChart(_mainData(c))),
        ],
      ),
    );
  }

  // دالة مساعدة لإنشاء أزرار الفلترة (Day, Week...) بشكل مشابه للصورة
  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.black : Colors.grey.shade600,
        ),
      ),
    );
  }

  // دالة إعداد بيانات الرسم البياني وتصميمه
  LineChartData _mainData(Adminhome c) {
    // 1. حساب القيم القصوى والدنيا لجعل الرسم متناسباً
    final spots = c.salesSpots;
    if (spots.isEmpty)
      return LineChartData(); // حالة احتياطية لو البيانات فارغة

    double minX = spots.first.x;
    double maxX = spots.last.x;
    // جعل الـ Y يرتفع قليلاً فوق أعلى قيمة ليكون الشكل أجمل
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1, // تأكد من إظهار التواريخ بشكل مناسب
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < c.apidata[0].salesChart!.length) {
                String date = c.apidata[0].salesChart![index].date!;
                // اختصار التاريخ مثلاً من "2026-05-23" إلى "23" أو كما تحب
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    date.substring(8),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              // جلب البيانات الأصلية من الـ API بناءً على الـ index
              final data = c.apidata[0].salesChart![spot.x.toInt()];
              return LineTooltipItem(
                "${data.date}\n\$${spot.y.toStringAsFixed(0)}",
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blue.shade700,
          barWidth: 2.5,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.blue.shade700,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.blue.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
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
