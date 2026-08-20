import 'package:get/get.dart';
String? validInput(String val, int min, int max, String type) {
  final value = val.trim();

  if (value.isEmpty) {
    return "Can't be empty";
  }

  if (type == 'username') {
    if (!GetUtils.isUsername(value)) {
      return "Not a valid username";
    }
  }

  if (type == 'email') {
    if (!GetUtils.isEmail(value)) {
      return "Not a valid email";
    }
  }

  if (type == 'password') {
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(value)) {
      return "Password must contain letters and numbers";
    }
  }

  if (value.length < min) {
    return "Can't be less than $min characters";
  }

  if (value.length > max) {
    return "Can't be greater than $max characters";
  }

  return null;
}
