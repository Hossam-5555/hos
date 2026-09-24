import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Dashboarddata {
  Crud crud;
  Dashboarddata(this.crud);

  // 1. جلب النظرة العامة و الـ KPIs
  Future<dynamic> getOverview({bool isRefresh = false}) async {
    String url = "${LinkApi.analyticsOverview}${isRefresh ? '?refresh=true' : ''}";
    var response = await crud.getrequset(url);
    return response.fold((l) => l, (r) => r);
  }

  // 2. جلب رسم المبيعات (أسبوعي / شهري)
  Future<dynamic> getChartData({String period = 'weekly', bool isRefresh = false}) async {
    String url = "${LinkApi.analyticsChart}?period=$period${isRefresh ? '&refresh=true' : ''}";
    var response = await crud.getrequset(url);
    return response.fold((l) => l, (r) => r);
  }

  // 3. جلب التفاصيل (العملاء، الأكثر مبيعاً، طرق الدفع)
  Future<dynamic> getDetails({bool isRefresh = false}) async {
    String url = "${LinkApi.analyticsDetails}${isRefresh ? '?refresh=true' : ''}";
    var response = await crud.getrequset(url);
    return response.fold((l) => l, (r) => r);
  }
}