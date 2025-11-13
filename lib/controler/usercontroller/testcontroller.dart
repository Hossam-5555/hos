import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';

class Testcontroller extends GetxController {
  Addresdata addresdata = Get.put(Addresdata(Get.find()));
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.put(Myservisec());
  List categories = [];
  List displayedProducts = []; // المنتجات المعروضة حاليًا
  int itemsToShow = 3;
  void loadProducts() {
    // مثال لبيانات مؤقتة
    displayedProducts = categories.take(itemsToShow).toList();
    update();
  }

  void showMore() {
    if (itemsToShow < categories.length) {
      itemsToShow += 6; // كل ضغطة تزود 6 منتجات
      displayedProducts = categories.take(itemsToShow).toList();
      update();
    }
  }

  @override
  void onInit() {
    // getposition();
    super.onInit();
  }
  // var x = 20.0.obs;
  // var y = 500.0.obs;

  // void fun(DragUpdateDetails details) {
  //   x.value += details.delta.dx;
  //   y.value += details.delta.dy;
  // }
  // StreamSubscription<Position>? positionStream;
  // Future<Position?> getposition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (serviceEnabled == false) {
  //     return null;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();

  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //       'Location permissions are permanently denied, we cannot request permissions.',
  //     );
  //   }
  //   if (permission == LocationPermission.whileInUse) {
  //     // positionStream = Geolocator.getPositionStream().listen((
  //     //   Position? position,
  //     // ) {
  //     //   print(
  //     //     '======${position!.latitude}'
  //     //     '======${position.longitude}',
  //     //   );
  //     // });
  //   }
  // }

  // @override
  // void dispose() {
  //   if (positionStream != null) {
  //     positionStream!.cancel();
  //   }
  //   super.dispose();
  // }
}
