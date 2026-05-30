import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Dashboarddata {
  Crud crud;
  Dashboarddata(this.crud);

  getdata() async {
    var response = await crud.getrequset(LinkApi.dashborddata);
    return response.fold((l) => l, (r) => r);
  }

  
}
