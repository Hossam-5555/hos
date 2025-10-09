import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myservisec extends GetxService {
  late SharedPreferences sharedPreferences;
  Future<Myservisec> init() async {
    await Firebase.initializeApp();
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}

Future<void> initialservisec() async {
  await Get.putAsync(() => Myservisec().init());
}
