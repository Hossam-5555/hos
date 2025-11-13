import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Notificationdata {
  Crud crud;
  Notificationdata(this.crud);

  GetNotification(String userid) async {
    var response = await crud.postrequset(LinkApi.notification, {
      "userid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
