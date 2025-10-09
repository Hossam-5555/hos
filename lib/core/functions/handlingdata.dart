import 'package:hos/core/class/crud.dart';

handling(response) {
  if (response is Statusrequest) {
    return response;
  } else {
    return Statusrequest.success;
  }
}
