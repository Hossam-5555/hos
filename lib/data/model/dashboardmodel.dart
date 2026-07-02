class DashboardResponse {
  final double totalSales;
  final int totalOrders;
  final int activeProducts;
  final int customers;
  final List<SalesChart> salesChart;
  final OrderStats orderStats;
  final AnalyticsMetrics analytics;

  DashboardResponse({
    required this.totalSales,
    required this.totalOrders,
    required this.activeProducts,
    required this.customers,
    required this.salesChart,
    required this.orderStats,
    required this.analytics,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      totalSales: (json['total_sales'] ?? 0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      activeProducts: json['active_products'] ?? 0,
      customers: json['customers'] ?? 0,
      salesChart: (json['sales_chart'] as List)
          .map((e) => SalesChart.fromJson(e))
          .toList(),
      orderStats: OrderStats.fromJson(json['order_stats'] ?? {}),
      analytics: AnalyticsMetrics.fromJson(json['analytics'] ?? {}),
    );
  }
}

class OrderStats {
  final OrderStatusDetail fulfilled;
  final OrderStatusDetail pending;
  final OrderStatusDetail cancelled;

  OrderStats({
    required this.fulfilled,
    required this.pending,
    required this.cancelled,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      fulfilled: OrderStatusDetail.fromJson(json['fulfilled'] ?? {}),
      pending: OrderStatusDetail.fromJson(json['pending'] ?? {}),
      cancelled: OrderStatusDetail.fromJson(json['cancelled'] ?? {}),
    );
  }
}

class OrderStatusDetail {
  final int value;
  final double percentage;
  final String label;
  final String color;

  OrderStatusDetail({
    required this.value,
    required this.percentage,
    required this.label,
    required this.color,
  });

  factory OrderStatusDetail.fromJson(Map<String, dynamic> json) {
    return OrderStatusDetail(
      value: json['value'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      label: json['label'] ?? '',
      color: json['color'] ?? '#000000',
    );
  }
}

class AnalyticsMetrics {
  final double conversionRate;
  final double avgOrderValue;
  final double refundRate;

  AnalyticsMetrics({
    required this.conversionRate,
    required this.avgOrderValue,
    required this.refundRate,
  });

  factory AnalyticsMetrics.fromJson(Map<String, dynamic> json) {
    return AnalyticsMetrics(
      conversionRate: (json['conversion_rate'] ?? 0).toDouble(),
      avgOrderValue: (json['avg_order_value'] ?? 0).toDouble(),
      refundRate: (json['refund_rate'] ?? 0).toDouble(),
    );
  }
}

class SalesChart {
  String? date;
  String? total;

  SalesChart({this.date, this.total});

  SalesChart.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['total'] = this.total;
    return data;
  }
}