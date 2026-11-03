import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/admin_controller.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/data/datasource/admindata/dashboarddata.dart';
import 'package:hos/veiw/wedget/pricecard.dart';

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
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => c.getdashboardapi(isRefresh: true),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  const SizedBox(height: 20),

                  // نظرة عامة (KPIs)
                  _OverviewGrid(overview: c.overviewData),
                  const SizedBox(height: 20),

                  // نمو الإيرادات
                  _RevenueChartCard(controller: c),
                  const SizedBox(height: 22),

                  const _SectionTitle('المبيعات'),
                  const SizedBox(height: 12),
                  _SalesByCategoryCard(
                    categories: List<Map<String, dynamic>>.from(
                      c.detailsData['sales_by_category'] ?? [],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // _SalesByProductCard(products: c.salesByProduct),
                  // const SizedBox(height: 22),
                  const _SectionTitle('العملاء'),
                  const SizedBox(height: 12),
                  _CustomersOverviewRow(
                    customers: Map<String, dynamic>.from(
                      c.detailsData['customers_overview'] ?? {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TopCustomersCard(
                    topCustomers: List<Map<String, dynamic>>.from(
                      c.detailsData['top_customers'] ?? [],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const _SectionTitle('المنتجات والمخزون'),
                  const SizedBox(height: 12),
                  _BestSellingProductsCard(products: c.salesByProduct),
                  const SizedBox(height: 12),
                  _StockStatusCard(
                    stockList: List<Map<String, dynamic>>.from(
                      c.detailsData['stock_status'] ?? [],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const _SectionTitle('الطلبات والدفع'),
                  const SizedBox(height: 12),
                  _OrderStatsPieCard(
                    orderStats: Map<String, dynamic>.from(
                      c.detailsData['order_stats'] ?? {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PaymentMethodsCard(
                    payments: List<Map<String, dynamic>>.from(
                      c.detailsData['payment_methods'] ?? [],
                    ),
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

// =============================== العناصر والـ Cards ===============================

class _OverviewGrid extends StatelessWidget {
  final Map<String, dynamic> overview;
  const _OverviewGrid({required this.overview});

  @override
  Widget build(BuildContext context) {
    final totalSales = (overview['total_sales'] ?? 0) as num;
    final totalOrders = (overview['total_orders'] ?? 0) as num;
    final avgOrderValue = (overview['avg_order_value'] ?? 0) as num;
    final refundRate = (overview['refund_rate'] ?? 0) as num;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2,
      children: [
        _KpiCard(
          'إجمالي الإيرادات',
          _compact(totalSales),
          Icons.payments_rounded,
          AppColors.primary,
        ),
        _KpiCard(
          'إجمالي الطلبات',
          _compact(totalOrders),
          Icons.receipt_long_rounded,
          AppColors.purple,
        ),
        _KpiCard(
          'متوسط الطلب',
          avgOrderValue.toStringAsFixed(0),
          Icons.shopping_bag_rounded,
          AppColors.success,
        ),
        _KpiCard(
          'معدل الاسترجاع',
          '$refundRate%',
          Icons.trending_up_rounded,
          AppColors.orange,
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueChartCard extends StatelessWidget {
  final Adminhome controller;
  const _RevenueChartCard({required this.controller});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: controller.isChartLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.salesSpots.isEmpty
                ? const Center(child: Text('لا توجد بيانات كافية'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: controller.salesSpots.length * 50.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(
                          builder: (context) {
                            // 1. حساب أكبر قيمة Y في البيانات المتاحة
                            final double maxYValue = controller.salesSpots
                                .map((spot) => spot.y)
                                .fold(0.0, (max, val) => val > max ? val : max);

                            final lineBarData = LineChartBarData(
                              spots: controller.salesSpots,
                              isCurved: true,
                              color: AppColors.english,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.warning.withAlpha(38),
                              ),
                            );

                            return LineChart(
                              LineChartData(
                                minX: 1,
                                maxX: controller.salesSpots.length.toDouble(),

                                // 2. إعطاء مساحة أمان 20% فوق أعلى نقطة ليظهر النص بدون قص
                                maxY: maxYValue * 1.2,

                                showingTooltipIndicators: controller.salesSpots
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      return ShowingTooltipIndicators([
                                        LineBarSpot(
                                          lineBarData,
                                          0,
                                          entry.value,
                                        ),
                                      ]);
                                    })
                                    .toList(),

                                lineTouchData: LineTouchData(
                                  enabled: false,
                                  touchTooltipData: LineTouchTooltipData(
                                    fitInsideVertically:
                                        true, // 3. إجبار النص على البقاء داخل الشاشة عمودياً
                                    getTooltipColor: (spot) =>
                                        Colors.transparent,
                                    tooltipMargin: 4,
                                    tooltipPadding: EdgeInsets.zero,
                                    getTooltipItems:
                                        (List<LineBarSpot> touchedSpots) {
                                          return touchedSpots.map((spot) {
                                            return LineTooltipItem(
                                              '${spot.y.toInt()}',
                                              const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            );
                                          }).toList();
                                        },
                                  ),
                                ),

                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true),
                                  ), // إخفاء محور X
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [lineBarData],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SalesByCategoryCard extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const _SalesByCategoryCard({required this.categories});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 8),
          if (categories.isEmpty) const Text('لا توجد بيانات متاحة'),
          ...categories.map((c) {
            // تحويل آمن من String إلى num
            final rawTotal = c['total'];
            final num total = rawTotal is num
                ? rawTotal
                : (num.tryParse(rawTotal?.toString() ?? '0') ?? 0);

            return _BarRow(
              label: c['name'] ?? 'غير معروف',
              percent: 0.5, // قيمة تقريبية للمؤشر
              trailing: _compact(total).toString(),
              color: AppColors.primary,
            );
          }),
        ],
      ),
    );
  }
}

// class _SalesByProductCard extends StatelessWidget {
//   final List<SalesByProductModel> products;
//   const _SalesByProductCard({required this.products});

//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'المبيعات حسب المنتج',
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           if (products.isEmpty) const Text('لا توجد بيانات متاحة'),
//           ...products.map((p) {
//             // تحويل آمن من String إلى num
//             final rawTotal = p.total;
//             final num total = rawTotal;

//             return _BarRow(
//               label: p.name,
//               percent: 0.6,
//               trailing: _compact(total).toString(),
//               color: AppColors.purple,
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

class _CustomersOverviewRow extends StatelessWidget {
  final Map<String, dynamic> customers;
  const _CustomersOverviewRow({required this.customers});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MiniStat(
            'إجمالي العملاء',
            '${customers['total_customers'] ?? 0}',
            Icons.group_rounded,
            AppColors.primary,
          ),
          _MiniStat(
            'عملاء جدد (30 يوم)',
            '${customers['new_customers'] ?? 0}',
            Icons.person_add_rounded,
            AppColors.success,
          ),
          _MiniStat(
            'نسبة التكرار',
            '${customers['returning_customers_pct'] ?? 0}%',
            Icons.repeat_rounded,
            AppColors.orange,
          ),
        ],
      ),
    );
  }
}

class _TopCustomersCard extends StatelessWidget {
  final List<Map<String, dynamic>> topCustomers;
  const _TopCustomersCard({required this.topCustomers});

  @override
  Widget build(BuildContext context) {
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
          if (topCustomers.isEmpty) const Text('لا توجد بيانات متاحة'),
          ...topCustomers.map((c) {
            // تحويل آمن للمبلغ الإجمالي
            final rawSpent = c['total_spent'];
            final num totalSpent = rawSpent is num
                ? rawSpent
                : (num.tryParse(rawSpent?.toString() ?? '0') ?? 0);

            // تحويل آمن لعدد الطلبات
            final rawOrders = c['orders_count'];
            final num ordersCount = rawOrders is num
                ? rawOrders
                : (num.tryParse(rawOrders?.toString() ?? '0') ?? 0);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    c['name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text('$ordersCount طلبات | ${_compact(totalSpent)}'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BestSellingProductsCard extends StatelessWidget {
  final List<SalesByProductModel> products;
  const _BestSellingProductsCard({required this.products});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: List.generate(products.length, (index) {
          final product = products[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == products.length - 1 ? 0 : 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E5ED),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: CachedNetworkImage(
                      imageUrl: product.image ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                     PriceText(
                       product.total,
                      color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StockStatusCard extends StatelessWidget {
  final List<Map<String, dynamic>> stockList;
  const _StockStatusCard({required this.stockList});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نقص المخزون',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (stockList.isEmpty) const Text('المخزون بوضع جيد 👍'),
          ...stockList.map((item) {
            final isOut = item['is_out_of_stock'] == true;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['name'] ?? ''),
                  Text(
                    isOut ? 'نفذ' : '${item['stock']} متبقي',
                    style: TextStyle(
                      color: isOut ? AppColors.danger : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _OrderStatsPieCard extends StatelessWidget {
  final Map<String, dynamic> orderStats;
  const _OrderStatsPieCard({required this.orderStats});

  @override
  Widget build(BuildContext context) {
    final fulfilled = (orderStats['fulfilled']?['percentage'] ?? 0) as num;
    final pending = (orderStats['pending']?['percentage'] ?? 0) as num;
    final cancelled = (orderStats['cancelled']?['percentage'] ?? 0) as num;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حالة الطلبات',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatusText('مكتمل', '$fulfilled%', AppColors.success),
              _StatusText('معلق', '$pending%', AppColors.warning),
              _StatusText('ملغي', '$cancelled%', AppColors.danger),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodsCard extends StatelessWidget {
  final List<Map<String, dynamic>> payments;

  const _PaymentMethodsCard({required this.payments});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'طرق الدفع المستخدمة',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: payments.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final payment = payments[index];

              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withAlpha(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      payment['payment_method'] == "credit"
                          ? Icons.wallet
                          : payment['payment_method'] == "card"
                          ? Icons.credit_card_rounded
                          : Icons.monetization_on_outlined,
                      size: 26,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      payment['payment_method']?.toString() ?? 'غير محدد',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${payment['count'] ?? 0} طلب',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Helper Components
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(40)),

        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
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

class _TimeToggle extends StatelessWidget {
  final Adminhome controller;
  const _TimeToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChoiceChip(
          label: const Text('monthly', style: TextStyle(fontSize: 11)),
          selected: controller.selectedtime == 0,
          onSelected: (_) => controller.changetime(0),
        ),
        const SizedBox(width: 5),
        ChoiceChip(
          label: const Text('yearly', style: TextStyle(fontSize: 11)),
          selected: controller.selectedtime == 1,
          onSelected: (_) => controller.changetime(1),
        ),
      ],
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final double percent;
  final String trailing;
  final Color color;

  const _BarRow({
    required this.label,
    required this.percent,
    required this.trailing,
    required this.color,
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
              PriceText(trailing),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent,
            color: color,
            backgroundColor: color.withAlpha(38),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _StatusText extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusText(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
