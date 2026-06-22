import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/AdminHome.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class AdminHome2 extends StatelessWidget {
  AdminHome2({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Adminhome());
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await c.getdashboardapi();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                StatsSection(c: c),
                const SizedBox(height: 20),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Titles(title: "Sales Overview"),
                ),
                Skeletonizer(
                  enabled: c.statusrequest == Statusrequest.loading,
                  child: SalesChart(c: c),
                ),
                const SizedBox(height: 20),
                const RecentOrders(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
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

// ignore: must_be_immutable
class SalesChart extends StatelessWidget {
  SalesChart({super.key, required this.c});
  List x = ["Day", "Week", "Month", "Year"];

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
      ),
      child: Column(
        // تم التعديل من Row إلى Column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الجزء العلوي: العنوان وأزرار الفلترة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: List.generate(x.length, (i) {
                    return GetBuilder<Adminhome>(
                      builder: (controller) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.decelerate,
                        // التعديل هنا: بنستخدم الـ transitionBuilder الافتراضي أو المخصص بتاعك
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child, // بنباصي الـ child اللي جاي من بره
                          );
                        },
                        child: _buildFilterChip(
                          x[i],
                          c.selectedtime == i,
                          i,
                          c,
                        ), // الكي بيتغير لما الـ state تتغير),
                      ),
                    );
                  }),
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
  Widget _buildFilterChip(
    String label,
    bool isSelected,
    int i,
    Adminhome controller,
  ) {
    return InkWell(
      onTap: () {
        controller.changetime(i); // تغيير الوقت
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250), // أنميشن ناعم للخلفية
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(6),
        
        ),
        // الـ AnimatedSwitcher هنا جوه عشان يعمل الـ Scale للـ Text بس لما يتحول لـ Bold
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          // الـ Key هنا متوقف على الـ label والـ state دي بس فمش هيأثر على جيرانه
          child: Text(
            label,
            key: ValueKey<String>('${label}_$isSelected'),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  // دالة إعداد بيانات الرسم البياني وتصميمه
  LineChartData _mainData(Adminhome c) {
    final spots = c.salesSpots;

    // 🟢 تحقق إذا كانت البيانات فارغة لتفعيل وضع البيانات الوهمية
    final bool isEmpty = spots.isEmpty;

    // تجهيز المتغيرات الأساسية للرسم البياني
    double minX = 0;
    double maxY = 50; // ديفولت لو البيانات فاضية
    List<FlSpot> finalSpots = [];

    if (isEmpty) {
      // 1. صناعة نقاط وهمية منسقة وتصاعدية بشكل جمالي
      finalSpots = [
        const FlSpot(0, 20),
        const FlSpot(1, 35),
        const FlSpot(2, 25),
        const FlSpot(3, 45),
        const FlSpot(4, 30),
        const FlSpot(5, 40),
      ];
      minX = 0;
      maxY = 60;
    } else {
      // 2. استخدام البيانات الحقيقية إذا كانت متوفرة
      finalSpots = spots;
      minX = spots.first.x;
      maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;
    }

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              String showDate = "";

              if (isEmpty) {
                // تواريخ وهمية عند غياب البيانات
                List<String> dummyDates = ['01', '02', '03', '04', '05', '06'];
                if (index >= 0 && index < dummyDates.length) {
                  showDate = dummyDates[index];
                }
              } else {
                // التواريخ الحقيقية المستخرجة من الـ API
                if (c.apidata.isNotEmpty &&
                    c.apidata[0].salesChart != null &&
                    index >= 0 &&
                    index < c.apidata[0].salesChart!.length) {
                  String fullDate =
                      c.apidata[0].salesChart![index].date ?? "0000-00-00";
                  showDate = fullDate.length >= 10
                      ? fullDate.substring(8)
                      : fullDate;
                }
              }

              if (showDate.isNotEmpty) {
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    showDate,
                    style: TextStyle(
                      fontSize: 10,
                      // جعل النص رمادي باهت جداً في الحالة الوهمية
                      color: isEmpty ? Colors.grey.shade400 : Colors.grey,
                      fontWeight: isEmpty ? FontWeight.normal : FontWeight.bold,
                    ),
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

      minY: 0,
      maxY: maxY,
      lineTouchData: LineTouchData(
        // 🔴 تعطيل ميزة اللمس والـ Tooltip لو البيانات وهمية عشان المستخدم ميتلخبطش
        enabled: !isEmpty,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (c.apidata.isEmpty || c.apidata[0].salesChart == null) {
                return null;
              }
              final data = c.apidata[0].salesChart![spot.x.toInt()];
              return LineTooltipItem(textDirection: TextDirection.rtl,
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
          spots: finalSpots,
          isCurved: true,
          // 🎨 لو وهمي نخليه رمادي هادي، لو حقيقي يظهر باللون الأزرق المعتاد
          color: isEmpty ? Colors.grey.shade300 : Colors.blue.shade700,
          barWidth: isEmpty ? 2.0 : 2.5,
          dotData: FlDotData(
            show:
                !isEmpty, // إخفاء النقاط الدائرية تماماً في الحالة الوهمية لشكل أنظف
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
              colors: isEmpty
                  ? [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.0)]
                  : [
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
