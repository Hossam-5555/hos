import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/AdminHome.dart';

// عدّل المسار ده على مسار ملف الكنترولر (Adminhome) اللي بعتهولي

/// ============================================================================
/// ملاحظات مهمة قبل ما تستخدم الملف ده:
///
/// 1) الحاجات اللي متوصلة فعلاً بالـ API الحقيقي (من الكنترولر اللي بعتهولي):
///    - controller.isLoading
///    - controller.getdashboardapi()   (Pull to refresh)
///    - controller.salesSpots          (چارت الإيرادات - LineChart)
///    - controller.selectedtime / controller.changetime()  (تبديل أسبوعي/شهري)
///
/// 2) كل باقي الأرقام في الملف ده (Total Revenue, AOV, CLV, CAC, Top Customers,
///    Best Selling Products, ... إلخ) هي MOCK data مؤقتة عشان التصميم يشتغل
///    ويتعرض صح من غير ما يعتمد على شكل موديل DashboardResponse بتاعك اللي
///    مش متأكد منه. كل كارت فيه تعليق "// TODO(API)" يوضح منين المفروض
///    تيجي البيانات دي (مطابقة لأسماء الحقول في AnalyticsService.php).
///
/// 3) ابعتلي DashboardResponse model (أو الملف اللي فيه Dashboarddata) وهظبطلك
///    كل القيم دي تتوصل بالـ API الحقيقي على طول بدل الـ mock.
/// ============================================================================

const String kCurrency = 'EGP ';

// ألوان أساسية بتتحط مرة واحدة عشان تفضل متسقة في كل التطبيق
class _AppColors {
  static const primary = Color(0xFF3F6FFF);
  static const purple = Color(0xFF9B59B6);
  static const success = Color(0xFF2ECC71); // زي لون "fulfilled" في الباك اند
  static const warning = Color(0xFFFFA500); // زي لون "pending" في الباك اند
  static const danger = Color(0xFFFF5252); // زي لون "cancelled" في الباك اند
  static const orange = Color(0xFFFF9F43);
}

String _compact(num value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}

// =============================== الشاشة الرئيسية ===============================

class Adminhomedashboard extends StatelessWidget {
  const Adminhomedashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Adminhome>(
      builder: (c) {
        if (c.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: c.getdashboardapi,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  const SizedBox(height: 20),

                  // نظرة عامة (Total Revenue / Total Orders / AOV / Conversion Rate)
                  const _OverviewGrid(),
                  const SizedBox(height: 20),

                  // Revenue Growth (Weekly/Monthly) - متوصل فعلاً بالـ API
                  _RevenueChartCard(controller: c),
                  const SizedBox(height: 22),

                  const _SectionTitle('المبيعات'),
                  const SizedBox(height: 12),
                  const _SalesByCategoryCard(),
                  const SizedBox(height: 12),
                  const _SalesByProductCard(),
                  const SizedBox(height: 12),
                  const _RefundRateCard(),
                  const SizedBox(height: 22),

                  const _SectionTitle('العملاء'),
                  const SizedBox(height: 12),
                  const _CustomersOverviewRow(),
                  const SizedBox(height: 12),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _ReturningRateGaugeCard()),
                      SizedBox(width: 12),
                      Expanded(child: _ClvCacCard()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _TopCustomersCard(),
                  const SizedBox(height: 22),

                  const _SectionTitle('المنتجات'),
                  const SizedBox(height: 12),
                  const _BestSellingProductsCard(),
                  const SizedBox(height: 12),
                  const _StockStatusCard(),
                  const SizedBox(height: 12),
                  const _MostWishlistedCard(),
                  const SizedBox(height: 22),

                  const _SectionTitle('الطلبات'),
                  const SizedBox(height: 12),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _PieBreakdownCard(
                          title: 'حالة الطلبات',
                          // TODO(API): استبدلها بـ order_stats من AnalyticsService.php
                          items: [
                            _PieItem('مكتمل', 68, _AppColors.success),
                            _PieItem('قيد الانتظار', 22, _AppColors.warning),
                            _PieItem('ملغي', 10, _AppColors.danger),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(child: _DeliveryAbandonedCard()),
                    ],
                  ),
                  const SizedBox(height: 22),

                  const _SectionTitle('التسويق والأداء'),

                  const SizedBox(height: 12),
                  const _PieBreakdownCard(
                    title: 'طرق الدفع',
                    items: [
                      _PieItem('فيزا / ماستركارد', 46, _AppColors.primary),
                      _PieItem('الدفع عند الاستلام', 39, _AppColors.orange),
                      _PieItem('محفظة إلكترونية', 15, _AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.06))
            : null,
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final double percent; // 0..1
  final Color color;
  final String trailing;
  const _BarRow({
    required this.label,
    required this.percent,
    required this.color,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                trailing,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 7,
              backgroundColor: Theme.of(context).dividerColor.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieItem {
  final String label;
  final double value;
  final Color color;
  const _PieItem(this.label, this.value, this.color);
}

class _PieBreakdownCard extends StatelessWidget {
  final String title;
  final List<_PieItem> items;
  const _PieBreakdownCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 15,
                      sections: items
                          .map(
                            (e) => PieChartSectionData(
                              value: e.value,
                              color: e.color,
                              radius: 20,
                              title: '',
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: e.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    e.label,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${e.value.toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================== الهيدر ===============================

// =============================== نظرة عامة (KPI Grid) ===============================
// TODO(API): متوصلة بـ total_sales / total_orders / analytics.avg_order_value /
// analytics.conversion_rate من AnalyticsService.php

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String delta;
  final bool positive;
  _KpiData(
    this.label,
    this.value,
    this.icon,
    this.color,
    this.delta,
    this.positive,
  );
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      _KpiData(
        'إجمالي الإيرادات',
        '$kCurrency${_compact(446700)}',
        Icons.payments_rounded,
        _AppColors.primary,
        '+8.5%',
        true,
      ),
      _KpiData(
        'إجمالي الطلبات',
        _compact(1224),
        Icons.receipt_long_rounded,
        _AppColors.purple,
        '+4.6%',
        true,
      ),
      _KpiData(
        'متوسط قيمة الطلب',
        '$kCurrency${(446700 / 1224).toStringAsFixed(0)}',
        Icons.shopping_bag_rounded,
        _AppColors.success,
        '+2.1%',
        true,
      ),
      _KpiData(
        'معدل التحويل',
        '4.6%',
        Icons.trending_up_rounded,
        _AppColors.orange,
        '-0.6%',
        false,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (_, i) => _KpiCard(data: items[i]),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.label,
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(data.icon, color: data.color, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(
                data.positive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 12,
                color: data.positive ? _AppColors.success : _AppColors.danger,
              ),
              const SizedBox(width: 2),
              Text(
                data.delta,
                style: textTheme.bodySmall?.copyWith(
                  color: data.positive ? _AppColors.success : _AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================== Revenue Growth (Weekly/Monthly) ===============================
// دي بتستخدم بيانات حقيقية من الكنترولر (controller.salesSpots)

class _RevenueChartCard extends StatelessWidget {
  final Adminhome controller;
  const _RevenueChartCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final spots = controller.salesSpots;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نمو الإيرادات',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              _TimeToggle(controller: controller),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$kCurrency${_compact(446700)}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: spots.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد بيانات كافية بعد',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: _AppColors.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                _AppColors.primary.withOpacity(0.25),
                                _AppColors.primary.withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TimeToggle extends StatelessWidget {
  final Adminhome controller;
  const _TimeToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Adminhome>(
      builder: (c) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TimeChip(
              label: 'أسبوعي',
              selected: c.selectedtime == 0,
              onTap: () => c.changetime(0),
            ),
            _TimeChip(
              label: 'شهري',
              selected: c.selectedtime == 1,
              onTap: () => c.changetime(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TimeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

// =============================== المبيعات ===============================

class _SalesByCategoryCard extends StatelessWidget {
  const _SalesByCategoryCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): سيب الباك اند يرجع sales_by_category: [{name, percent, total}]
    const data = [
      ('إلكترونيات', 0.78, 'EGP 172K', _AppColors.primary),
      ('أزياء', 0.55, 'EGP 96K', _AppColors.purple),
      ('منزل ومطبخ', 0.40, 'EGP 61K', _AppColors.success),
      ('إكسسوارات', 0.24, 'EGP 33K', _AppColors.orange),
    ];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المبيعات حسب التصنيف',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          ...data.map(
            (e) => _BarRow(
              label: e.$1,
              percent: e.$2,
              trailing: e.$3,
              color: e.$4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesByProductCard extends StatelessWidget {
  const _SalesByProductCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): سيب الباك اند يرجع sales_by_product: [{name, percent, total}]
    const data = [
      ('سماعة لاسلكية', 0.85, 'EGP 124.8K', _AppColors.primary),
      ('ساعة كاسيو', 0.63, 'EGP 92.6K', _AppColors.purple),
      ('سامسونج S25', 0.51, 'EGP 74K', _AppColors.orange),
    ];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المبيعات حسب المنتج',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          ...data.map(
            (e) => _BarRow(
              label: e.$1,
              percent: e.$2,
              trailing: e.$3,
              color: e.$4,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundRateCard extends StatelessWidget {
  const _RefundRateCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): متوصلة بـ analytics.refund_rate من AnalyticsService.php
    return _Card(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _AppColors.danger.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.assignment_return_rounded,
              color: _AppColors.danger,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معدل الاسترجاع / الإلغاء',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '3.2%',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================== العملاء ===============================

class _CustomersOverviewRow extends StatelessWidget {
  const _CustomersOverviewRow();

  @override
  Widget build(BuildContext context) {
    // TODO(API): "إجمالي العملاء" متوصل بـ customers، والباقي محتاج endpoint جديد
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'العملاء',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.person_add_alt_1_rounded,
                  color: _AppColors.primary,
                  value: '312',
                  label: 'عملاء جدد',
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.group_rounded,
                  color: _AppColors.success,
                  value: '2.884',
                  label: 'إجمالي العملاء',
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.repeat_rounded,
                  color: _AppColors.orange,
                  value: '68%',
                  label: 'عملاء متكررين',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _MiniStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ReturningRateGaugeCard extends StatelessWidget {
  const _ReturningRateGaugeCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): معدل تكرار الشراء (Returning Customers Rate) محتاج endpoint جديد
    return _Card(
      child: Column(
        children: [
          Text(
            'معدل تكرار الشراء',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const _SemiGauge(percent: 0.68, color: _AppColors.success),
          Text('آخر 30 يوم', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SemiGauge extends StatelessWidget {
  final double percent; // 0..1
  final Color color;
  const _SemiGauge({required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CustomPaint(
        painter: _SemiGaugePainter(
          percent: percent,
          color: color,
          trackColor: Theme.of(context).dividerColor.withOpacity(0.25),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _SemiGaugePainter extends CustomPainter {
  final double percent;
  final Color color;
  final Color trackColor;
  _SemiGaugePainter({
    required this.percent,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2 - 10;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    const startAngle = pi;
    const sweepFull = pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull,
      false,
      trackPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull * percent,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SemiGaugePainter oldDelegate) =>
      oldDelegate.percent != percent;
}

class _ClvCacCard extends StatelessWidget {
  const _ClvCacCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): CLV و CAC محتاجين endpoint جديد في الباك اند
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قيمة العميل مدى الحياة',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            'EGP 1,240',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: _AppColors.primary,
            ),
          ),
          const Divider(height: 24),
          Text(
            'تكلفة اكتساب العميل',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            'EGP 86',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: _AppColors.purple,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCustomersCard extends StatelessWidget {
  const _TopCustomersCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): محتاج endpoint يرجع top_customers: [{name, total_spent, orders_count}]
    const customers = [
      ('أحمد محمود', 'EGP 12,400', 18),
      ('سارة علي', 'EGP 9,850', 14),
      ('محمد ياسر', 'EGP 8,120', 11),
    ];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أفضل العملاء',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...customers.map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: _AppColors.primary.withOpacity(0.15),
                    child: Text(
                      c.$1[0],
                      style: const TextStyle(
                        color: _AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      c.$1,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${c.$3} طلب',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    c.$2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================== المنتجات ===============================

class _BestSellingProductsCard extends StatelessWidget {
  const _BestSellingProductsCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): محتاج endpoint يرجع أفضل المنتجات مبيعاً (id, name, sold, revenue, rating)
    const products = [
      ('#3009', 'سماعة لاسلكية', '2.310 مباع', 'EGP 124.839', 5.0),
      ('#3010', 'ساعة كاسيو', '1.230 مباع', 'EGP 92.662', 4.8),
      ('#3014', 'سامسونج S25', '812 مباع', 'EGP 74.029', 4.3),
    ];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأكثر مبيعاً',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...products.map(
            (p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.$2,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${p.$1} · ${p.$3}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        p.$4,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _AppColors.success,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFFFC107),
                          ),
                          Text(
                            ' ${p.$5}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStatusCard extends StatelessWidget {
  const _StockStatusCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): محتاج endpoint للمنتجات اللي مخزونها منخفض أو نافد
    const items = [
      ('حذاء رياضي - مقاس 42', 3, false),
      ('سماعة بلوتوث X200', 0, true),
      ('شاحن سريع 65W', 5, false),
    ];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المخزون المنخفض / النافد',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: e.$3 ? _AppColors.danger : _AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e.$1,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    e.$3 ? 'نفذ' : '${e.$2} متبقي',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: e.$3 ? _AppColors.danger : _AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MostWishlistedCard extends StatelessWidget {
  const _MostWishlistedCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): محتاج endpoint يرجع المنتجات الأكثر إضافة للمفضلة
    const items = [
      ('سماعة لاسلكية', 412),
      ('حذاء رياضي', 305),
      ('ساعة ذكية', 260),
    ];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأكثر إضافة للمفضلة',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    size: 16,
                    color: _AppColors.danger,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e.$1,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    '${e.$2}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================== الطلبات ===============================

class _DeliveryAbandonedCard extends StatelessWidget {
  const _DeliveryAbandonedCard();

  @override
  Widget build(BuildContext context) {
    // TODO(API): متوسط وقت التوصيل والسلات المتروكة محتاجين endpoint جديد
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_shipping_rounded,
                size: 18,
                color: _AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'متوسط وقت التوصيل',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            '2.4 يوم',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(
                Icons.remove_shopping_cart_rounded,
                size: 18,
                color: _AppColors.orange,
              ),
              const SizedBox(width: 8),
              Text('سلات متروكة', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          Text(
            '186',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
