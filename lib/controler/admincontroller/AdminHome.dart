import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/dashboarddata.dart';
import 'package:hos/data/model/dashboardmodel.dart';
import 'package:hos/veiw/adminscreen/Home/AdminHome.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminpending.dart';

class Adminhome extends GetxController with GetSingleTickerProviderStateMixin {

int selectedtime=0;
changetime(int i){
  selectedtime=i;
  update();
}



late  AnimationController animatedContainer ;
  Dashboarddata data = Get.put(Dashboarddata(Get.find()));
  TextEditingController searchcontroller = TextEditingController();
  List<DashboardModel> apidata = [];
  Statusrequest statusrequest = Statusrequest.none;
  int currentpage = 0;
  List<FlSpot> get salesSpots {
    List<FlSpot> spots = [];
    // نفترض أن apidata[0] هو الكائن الذي يحتوي على sales_chart
    var chartData = apidata[0].salesChart;

    for (int i = 0; i < chartData!.length; i++) {
      // X هو ترتيب اليوم، Y هو قيمة المبيعات
      spots.add(FlSpot(i.toDouble(), double.parse(chartData[i].total!)));
    }
    return spots;
  }

  PageController controller = PageController();
  Future<void> getdashboardapi() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await data.getdata();
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      // التحقق من نجاح حالة الرد من السيرفر
      if (response['status'] == true && response['data'] != null) {
        // هنا نقوم بتنظيف القائمة القديمة إن وجدت
        apidata.clear();

        // بما أن الـ data تأتي كـ Map وليست List،
        // يجب تحويلها إلى موديل مباشرة وتخزينها
        DashboardModel model = DashboardModel.fromJson(response['data']);
        apidata.add(model);
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  // 👇 عند الضغط على BottomNavigationBar
  void changePage(int index) {
    currentpage = index;

    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    update();
  }

  // 👇 لما الصفحة تتغير
  void onpagechanged(int index) {
    currentpage = index;

    update();
  }

  List<Widget> pages = [
    AdminHome2(),
    Adminpending(),
    // ViewItemScreen(),
    ViewCategories(),
  ];
  List time = ["day", "mounth", "year"];

  List<List<dynamic>> title = [
    ["Dashboard", Icons.home],
    ["Orders", Icons.shopping_bag],
    ["Categories", Icons.category_outlined],
  ];
  @override
  void onInit() {
   animatedContainer = AnimationController(vsync: this,
    duration: Duration(milliseconds: 300),
  );
    getdashboardapi();
    super.onInit();
  }

  @override
  void onClose() {
    animatedContainer.dispose();
    super.onClose();
  }
}
