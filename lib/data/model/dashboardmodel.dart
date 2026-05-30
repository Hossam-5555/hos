class DashboardModel {
  int? totalSales;
  int? totalOrders;
  int? activeProducts;
  int? customers;
  List<SalesChart>? salesChart;

  DashboardModel(
      {this.totalSales,
      this.totalOrders,
      this.activeProducts,
      this.customers,
      this.salesChart});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    totalSales = json['total_sales'];
    totalOrders = json['total_orders'];
    activeProducts = json['active_products'];
    customers = json['customers'];
    if (json['sales_chart'] != null) {
      salesChart = <SalesChart>[];
      json['sales_chart'].forEach((v) {
        salesChart!.add(new SalesChart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_sales'] = this.totalSales;
    data['total_orders'] = this.totalOrders;
    data['active_products'] = this.activeProducts;
    data['customers'] = this.customers;
    if (this.salesChart != null) {
      data['sales_chart'] = this.salesChart!.map((v) => v.toJson()).toList();
    }
    return data;
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