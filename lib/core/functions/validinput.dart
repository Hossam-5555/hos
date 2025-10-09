import 'package:get/get.dart';

 validInput(String val, int min, int max, String type) {
  if (val.isEmpty) {
    return 'Can’t be Empty';
  }
  if (type == 'username') {
    if (!GetUtils.isUsername(val)) {
      return "not valid user name";
    }
  }

  if (type == 'email') {
    if (!GetUtils.isEmail(val)) {
      return "not valid  email";
    }
  }

  if (val.length < min) {
    return 'Can’t be less than $min';
  }
  if (val.length > max) {
    return 'Can’t be greter than $max';
  }
}
