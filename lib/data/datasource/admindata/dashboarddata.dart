import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Dashboarddata {
  Crud crud;
  Dashboarddata(this.crud);

  // 1. جلب النظرة العامة و الـ KPIs
  Future<dynamic> getOverview({bool isRefresh = false}) async {
    String url =
        "${LinkApi.analyticsOverview}${isRefresh ? '?refresh=true' : ''}";
    var response = await crud.getrequset(url);
    return response.fold((l) => l, (r) => r);
  }

  // 2. جلب رسم المبيعات (أسبوعي / شهري)
  Future<List<RevenueChartModel>> getChartData({
    String period = 'monthly',
    bool isRefresh = false,
  }) async {
    final url =
        "${LinkApi.analyticsChart}?period=$period"
        "${isRefresh ? '&refresh=true' : ''}";

    final response = await crud.getrequset(url);

    return response.fold((l) => [], (r) {
      if (r['status'] != true) return [];

      final data = r['data'];

      if (data is! List) return [];

      return data
          .map(
            (item) =>
                RevenueChartModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    });
  }

  // 3. جلب التفاصيل (العملاء، الأكثر مبيعاً، طرق الدفع)
  Future<dynamic> getDetails({bool isRefresh = false}) async {
    String url =
        "${LinkApi.analyticsDetails}${isRefresh ? '?refresh=true' : ''}";
    var response = await crud.getrequset(url);
    return response.fold((l) => l, (r) => r);
  }
}

class RevenueChartModel {
  final String date;
  final double total;

  RevenueChartModel({required this.date, required this.total});

  factory RevenueChartModel.fromJson(Map<String, dynamic> json) {
    final rawTotal = json['total'];

    final total = rawTotal is num
        ? rawTotal.toDouble()
        : double.tryParse(rawTotal?.toString() ?? '') ?? 0;

    return RevenueChartModel(date: json['date'].toString(), total: total);
  }
}
