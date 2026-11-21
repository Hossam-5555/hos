import 'dart:io';



 Future<bool> checkinterner() async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 2));
    return result.isNotEmpty &&
        result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}



