import 'package:fl_chart/fl_chart.dart';
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;

              // مسافات متجاوبة حسب عرض الشاشة (بحد أدنى وأقصى) عشان
              // تفضل مظبوطة على كل أنواع الهواتف والتابلت
              final double horizontalPadding = (width * 0.045).clamp(
                14.0,
                32.0,
              );
              final double sectionSpacing = (width * 0.05).clamp(16.0, 26.0);
              final bool isWide = width >= 600;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: sectionSpacing * 0.5,
                ),
                child: ListView(
                  children: [
                    SizedBox(height: sectionSpacing * 0.6),
                    StatsSection(c: c, isWide: isWide, width: width),
                    SizedBox(height: sectionSpacing),
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Titles(title: "Sales Overview"),
                    ),
                    SizedBox(height: sectionSpacing * 0.4),
                    Skeletonizer(
                      enabled: c.statusrequest == Statusrequest.loading,
                      child: SalesChart(c: c, width: width),
                    ),
                    SizedBox(height: sectionSpacing),
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Titles(title: "Analytics"),
                    ),
                    SizedBox(height: sectionSpacing * 0.4),
                    Skeletonizer(
                      enabled: c.statusrequest == Statusrequest.loading,
                      child: AnalyticsSection(
                        c: c,
                        width: width,
                        isWide: isWide,
                      ),
                    ),
                    SizedBox(height: sectionSpacing),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ================= Stats Section =================

// ignore: must_be_immutable
class StatsSection extends StatelessWidget {
  StatsSection({
    super.key,
    required this.c,
    required this.isWide,
    required this.width,
  });

  Adminhome c;
  final bool isWide;
  final double width;

  @override
  Widget build(BuildContext context) {
    final double spacing = (width * 0.025).clamp(8.0, 14.0);

    // Guard: الـ apidata لسه فاضية — نرجع placeholder بنفس شكل الكروت
    // عشان الـ Skeletonizer يرسمها صح ومفيش RangeError
    if (c.apidata.isEmpty && c.statusrequest == Statusrequest.loading) {
      final emptyCards = [
        StatCard(
          title: "Total Sales",
          value: r"$----",
          growth: "+---%",
          width: width,
        ),
        StatCard(
          title: "Total Orders",
          value: "----",
          growth: "+---%",
          width: width,
        ),
        StatCard(title: "Products", value: "---- Active", width: width),
        StatCard(
          title: "Customers",
          value: "----",
          growth: "+---%",
          width: width,
        ),
      ];
      if (isWide) {
        return Row(
          children: [
            for (int i = 0; i < emptyCards.length; i++) ...[
              if (i != 0) SizedBox(width: spacing),
              Expanded(child: emptyCards[i]),
            ],
          ],
        );
      }
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: emptyCards[0]),
              SizedBox(width: spacing),
              Expanded(child: emptyCards[1]),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(child: emptyCards[2]),
              SizedBox(width: spacing),
              Expanded(child: emptyCards[3]),
            ],
          ),
        ],
      );
    }

    final cards = [
      StatCard(
        title: "Total Sales",
        value: "\$${c.apidata[0].totalSales}",
        growth: "+8.5%",
        width: width,
      ),
      StatCard(
        title: "Total Orders",
        value: "${c.apidata[0].totalOrders}",
        growth: "+12%",
        width: width,
      ),
      StatCard(
        title: "Products",
        value: "${c.apidata[0].activeProducts} Active",
        width: width,
      ),
      StatCard(
        title: "Customers",
        value: "${c.apidata[0].customers}",
        growth: "+5%",
        width: width,
      ),
    ];

    // على الشاشات الواسعة (تابلت) الكروت الأربعة بتتعرض في صف واحد،
    // وعلى الهاتف بتفضل شبكة 2x2 زي ما كانت
    if (isWide) {
      return Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            if (i != 0) SizedBox(width: spacing),
            Expanded(child: cards[i]),
          ],
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            SizedBox(width: spacing),
            Expanded(child: cards[1]),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(child: cards[2]),
            SizedBox(width: spacing),
            Expanded(child: cards[3]),
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
  final double width;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.width,
    this.growth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardColor = isDark
        ? Colors.white.withAlpha(15)
        : Colors.white.withAlpha(140);
    final Color borderColor = isDark
        ? Colors.white.withAlpha(30)
        : Colors.grey.withAlpha(64);
    final Color titleColor = theme.colorScheme.onSurface.withAlpha(166);
    final Color valueColor = theme.colorScheme.onSurface;

    // كل الأحجام بتتحسب نسبة لعرض الشاشة عشان تفضل مظبوطة على أي هاتف
    final double cardPadding = (width * 0.04).clamp(12.0, 18.0);
    final double titleFontSize = (width * 0.033).clamp(11.0, 14.0);
    final double valueFontSize = (width * 0.05).clamp(16.0, 22.0);
    final double growthFontSize = (width * 0.032).clamp(11.0, 13.0);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: titleColor, fontSize: titleFontSize),
          ),
          SizedBox(height: (width * 0.02).clamp(6.0, 10.0)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          if (growth != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                growth!,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: growthFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ================= Sales Chart =================

// ignore: must_be_immutable
class SalesChart extends StatefulWidget {
  SalesChart({super.key, required this.c, required this.width});

  Adminhome c;
  final double width;

  static const List<String> _filters = ["Day", "Week", "Month", "Year"];

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  // بيتحول لـ true بعد أول فريم عشان الرسم البياني يتحرك من الصفر
  // لحد القيم الحقيقية، بدل ما يترسم مرة واحدة وهو واقف
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _animateIn = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double chartHeight = (widget.width * 0.62).clamp(220.0, 320.0);
    final double chartPadding = (widget.width * 0.04).clamp(12.0, 18.0);

    return Container(
      height: chartHeight,
      padding: EdgeInsets.all(chartPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha(26)
              : Colors.grey.withAlpha(38),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isDark
                      ? Colors.white.withAlpha(13)
                      : Colors.grey.withAlpha(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(SalesChart._filters.length, (i) {
                    return GetBuilder<Adminhome>(
                      builder: (controller) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.linearToEaseOut,
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        child: _buildFilterChip(
                          SalesChart._filters[i],
                          widget.c.selectedtime == i,
                          i,
                          widget.c,
                          isDark,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: (widget.width * 0.07).clamp(20.0, 32.0)),
          Expanded(
            child: LineChart(
              _mainData(widget.c, _animateIn),
              // 👇 دي اللي بتخلي الرسم البياني "يتحرك" لحد قيمته الحقيقية
              // بدل ما يترسم مرة واحدة على طول
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    int i,
    Adminhome controller,
    bool isDark,
  ) {
    return InkWell(
      onTap: () {
        controller.changetime(i);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white.withAlpha(230) : Colors.white)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            label,
            key: ValueKey<String>('${label}_$isSelected'),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.black
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ),
        ),
      ),
    );
  }

  // دالة إعداد بيانات الرسم البياني وتصميمه
  LineChartData _mainData(Adminhome c, bool animateIn) {
    final spots = c.salesSpots;
    final bool isEmpty = spots.isEmpty;

    double minX = 0;
    double maxY = 50;
    List<FlSpot> finalSpots = [];

    if (isEmpty) {
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
      finalSpots = spots;
      minX = spots.first.x;
      maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;
    }

    // في أول فريم لسه الرسم واقف عند صفر، وبعدها بيتحرك لحد القيم دي
    // بفضل الـ duration اللي حطيناها فوق على LineChart
    final List<FlSpot> displaySpots = animateIn
        ? finalSpots
        : finalSpots.map((s) => FlSpot(s.x, 0)).toList();

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
                List<String> dummyDates = ['01', '02', '03', '04', '05', '06'];
                if (index >= 0 && index < dummyDates.length) {
                  showDate = dummyDates[index];
                }
              } else {
                if (c.apidata.isNotEmpty &&
                    index >= 0 &&
                    index < c.apidata[0].salesChart.length) {
                  String fullDate =
                      c.apidata[0].salesChart[index].date ?? "0000-00-00";
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
        enabled: !isEmpty && animateIn,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (c.apidata.isEmpty) {
                return null;
              }
              final data = c.apidata[0].salesChart[spot.x.toInt()];
              return LineTooltipItem(
                textDirection: TextDirection.rtl,
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
          spots: displaySpots,
          isCurved: true,
          color: isEmpty ? Colors.grey.shade300 : Colors.blue.shade700,
          barWidth: isEmpty ? 2.0 : 2.5,
          dotData: FlDotData(
            show: !isEmpty && animateIn,
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
                  ? [Colors.grey.withAlpha(26), Colors.grey.withAlpha(0)]
                  : [Colors.blue.withAlpha(51), Colors.blue.withAlpha(0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}

// ================= Analytics (replaces Recent Orders) =================

/// شريحة واحدة في الـ Pie chart (Fulfilled / Pending / Cancelled)
class _AnalyticsSlice {
  final String label;
  final double value; // نسبة مئوية
  final Color color;
  const _AnalyticsSlice(this.label, this.value, this.color);
}

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({
    super.key,
    required this.c,
    required this.width,
    required this.isWide,
  });

  final Adminhome c;
  final double width;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardColor = isDark
        ? Colors.white.withAlpha(15)
        : Colors.white.withAlpha(140);
    final Color borderColor = isDark
        ? Colors.white.withAlpha(30)
        : Colors.grey.withAlpha(64);

    final double cardPadding = (width * 0.045).clamp(14.0, 20.0);
    final double pieSize = (width * 0.34).clamp(110.0, 170.0);

    // Guard: نفس منطق StatsSection — لو apidata لسه فاضية، منعرضش
    // بيانات وهمية بأرقام مضروبة، بس placeholder صفري آمن للـ Skeletonizer
    final bool hasData = c.apidata.isNotEmpty;
    final orderStats = hasData ? c.apidata[0].orderStats : null;
    final analytics = c.apidata.isNotEmpty ? c.apidata[0].analytics : null;

    final List<_AnalyticsSlice> orderStatusData = orderStats == null
        ? const [
            _AnalyticsSlice("Fulfilled", 0, Colors.green),
            _AnalyticsSlice("Pending", 0, Colors.orange),
            _AnalyticsSlice("Cancelled", 0, Colors.red),
          ]
        : [
            _AnalyticsSlice(
              "Fulfilled",
              orderStats.fulfilled.percentage,
              Colors.green,
            ),
            _AnalyticsSlice(
              "Pending",
              orderStats.pending.percentage,
              Colors.orange,
            ),
            _AnalyticsSlice(
              "Cancelled",
              orderStats.cancelled.percentage,
              Colors.red,
            ),
          ];

    final List<Map<String, String>> kpis = [
      {
        "label": "Conversion Rate",
        "value": analytics == null ? "--%" : "${analytics.conversionRate}%",
      },
      {
        "label": "Avg. Order Value",
        "value": analytics == null ? "\$--" : "\$${analytics.avgOrderValue}",
      },
      {
        "label": "Refund Rate",
        "value": analytics == null ? "--%" : "${analytics.refundRate}%",
      },
    ];

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صف الـ KPIs السريعة
          Wrap(
            spacing: (width * 0.03).clamp(10.0, 18.0),
            runSpacing: 10,
            children: kpis.map((kpi) {
              return _KpiChip(
                label: kpi["label"]!,
                value: kpi["value"]!,
                width: width,
              );
            }).toList(),
          ),
          SizedBox(height: (width * 0.06).clamp(18.0, 26.0)),

          // توزيع حالة الطلبات: Pie chart + Legend
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _OrdersPieChart(size: pieSize, data: orderStatusData),
                    SizedBox(width: (width * 0.04).clamp(14.0, 24.0)),
                    Expanded(
                      child: _OrdersLegend(data: orderStatusData, width: width),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _OrdersPieChart(size: pieSize, data: orderStatusData),
                    SizedBox(height: (width * 0.04).clamp(14.0, 20.0)),
                    _OrdersLegend(data: orderStatusData, width: width),
                  ],
                ),
        ],
      ),
    );
  }
}

class _KpiChip extends StatelessWidget {
  const _KpiChip({
    required this.label,
    required this.value,
    required this.width,
  });

  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (width * 0.03).clamp(10.0, 14.0),
        vertical: (width * 0.02).clamp(8.0, 10.0),
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(15) : Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: (width * 0.03).clamp(10.0, 12.0),
              color: theme.colorScheme.onSurface.withAlpha(153), // 0.6 * 255
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: (width * 0.038).clamp(13.0, 16.0),
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersPieChart extends StatelessWidget {
  const _OrdersPieChart({required this.size, required this.data});

  final double size;
  final List<_AnalyticsSlice> data;

  @override
  Widget build(BuildContext context) {
    // لو كل القيم صفر (زي وقت الـ loading قبل وصول الـ API) بنعرض
    // دائرة رمادية محايدة بدل ما نسيب fl_chart يتعامل مع مجموع = 0
    final bool allZero = data.every((s) => s.value <= 0);
    final sections = allZero
        ? [
            PieChartSectionData(
              value: 1,
              color: Colors.grey.withAlpha(64),
              radius: size * 0.22,
              showTitle: false,
            ),
          ]
        : data.where((s) => s.value > 0).map((slice) {
            return PieChartSectionData(
              value: slice.value,
              color: slice.color,
              radius: size * 0.22,
              showTitle: false,
            );
          }).toList();

    return SizedBox(
      width: size,
      height: size,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: size * 0.28,
          startDegreeOffset: -90,
          sections: sections,
        ),
        swapAnimationDuration: const Duration(milliseconds: 700),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }
}

class _OrdersLegend extends StatelessWidget {
  const _OrdersLegend({required this.data, required this.width});

  final List<_AnalyticsSlice> data;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: data.map((slice) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: slice.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  slice.label,
                  style: TextStyle(
                    fontSize: (width * 0.033).clamp(12.0, 14.0),
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              Text(
                "${slice.value.toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: (width * 0.033).clamp(12.0, 14.0),
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
