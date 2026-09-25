// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/controler/usercontroller/home/homepage_controller.dart';
import 'package:hos/controler/usercontroller/home/homescreen_controller.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/veiw/adminscreen/admin_homescreen.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/viewitem.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/checkout.dart';
import 'package:hos/veiw/userscreen/screen/home/home_page.dart';
import 'package:hos/veiw/userscreen/screen/home/items.dart';
import 'package:hos/core/middilware/midelware.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/forgetpass.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/resetpass.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/veryficode.dart';
import 'package:hos/veiw/userscreen/screen/auth/auth.dart';
import 'package:hos/veiw/userscreen/screen/home/homescreen.dart';
import 'package:hos/veiw/userscreen/screen/home/itemsdetailes.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
import 'package:hos/veiw/userscreen/screen/myfavorite.dart';
import 'package:hos/veiw/userscreen/screen/profile/addres/add.dart';
import 'package:hos/veiw/userscreen/screen/profile/addres/viewaddres.dart';
import '../../veiw/userscreen/screen/profile/order/orders.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: '/', page: () => AuthPage(), middlewares: [Midelware()]),

  // ─── Admin ───────────────────────────────────────────
  GetPage(name: AdminApproate.adminHome, page: () => AdminHome()),
  GetPage(name: AdminApproate.viewitemscreen, page: () => ViewItemScreen()),

  // ─── Home ─────────────────────────────────────────────
  GetPage(
    name: Approute.Homescreen,
    page: () => Homescreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => Homescreencontroller(), fenix: true);
      Get.lazyPut(() => HomepageController(), fenix: true);
    }),
  ),

  GetPage(
    name: Approute.Homepage,
    page: () => HomePage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => HomepageController(), fenix: true);
    }),
  ),

  GetPage(
    name: Approute.Items,
    page: () => Items(),
    // ضيف ItemsController لو عندك
    // binding: BindingsBuilder(() {
    //   Get.lazyPut(() => ItemsController());
    // }),
  ),

  GetPage(
    name: Approute.Itemsdetailes,
    page: () => Itemsdetailes(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => Itemdetailscontroller());
    }),
  ),

  GetPage(name: Approute.notificationPage, page: () => NotificationPage()),

  // ─── Cart & Checkout ──────────────────────────────────
  GetPage(
    name: Approute.ShoppingCartPage,
    page: () => ShoppingCartPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => CartController(), fenix: true);
    }),
  ),

  GetPage(
    name: Approute.Checkout,
    page: () => Checkout(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => Checkoutcontroller());
    }),
  ),

  // ─── Favorite ─────────────────────────────────────────
  GetPage(name: Approute.myfavorite, page: () => Myfavorite()),

  // ─── Orders ───────────────────────────────────────────
  GetPage(
    name: Approute.Orders,
    page: () => Orders(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => Ordercontroller());
    }),
  ),

  // ─── Auth ─────────────────────────────────────────────
  // GetPage(name: Approute.login, page: () => AuthPage()),
  GetPage(name: Approute.checkemailpage, page: () => ForgetPass()),
  GetPage(name: Approute.Veryficode, page: () => Veryficode()),
  GetPage(name: Approute.Resetpass, page: () => Resetpass()),

  // ─── Settings ─────────────────────────────────────────
  GetPage(
    name: Approute.viewmyaddres,
    page: () => ViewMyAddres(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => AddressController());
    }),
  ),
  GetPage(name: Approute.addnewaddres, page: () => AddNewAddres()),
];

// ─────────────────────────────────────────
class Approute {
  static String Homescreen = "/Homescreen";
  static String Homepage = "/Homepage";
  static String Items = "/Items";
  static String Itemsdetailes = "/Itemsdetailes";
  static String notificationPage = "/notificationPage";
  static String ShoppingCartPage = "/ShoppingCartPage";
  static String Checkout = "/checkout";
  static String myfavorite = "/myfavorite";
  static String Orders = "/Orders";
  static String login = "/login";
  static String checkemailpage = "/checkemailpage";
  static String Veryficode = "/Veryficode";
  static String Resetpass = "/Resetpass";
  static String Onboarding = "/Onboarding";
  static String language = "/language";
  static String viewmyaddres = "/viewmyaddres";
  static String addnewaddres = "/addnewaddres";
}

class AdminApproate {
  static const String adminHome = "/adminHome";
  static const String viewitemscreen = "/ViewItemScreen";
}
