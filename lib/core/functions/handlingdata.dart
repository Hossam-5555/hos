import 'package:hos/data/services/crud.dart';

handling(response) {
  if (response is Statusrequest) {
    return response;
  } else {
    return Statusrequest.success;
  }
}
