import 'dart:io';

 Future<dynamic> checkinterner() async {
  var result = await InternetAddress.lookup("google.com");
  try {
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
