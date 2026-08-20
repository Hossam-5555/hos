// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:hos/veiw/adminscreen/Adminhomescreen.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/viewitem.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/checkout.dart';
import 'package:hos/veiw/userscreen/screen/home/Homepage.dart';
import 'package:hos/veiw/userscreen/screen/home/items.dart';
import 'package:hos/core/middilware/midelware.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/forgetpass.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/resetpass.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/veryficode.dart';
import 'package:hos/veiw/userscreen/screen/auth/Auth.dart';
import 'package:hos/veiw/userscreen/screen/auth/veryfisign.dart';
import 'package:hos/veiw/userscreen/screen/home/homescreen.dart';
import 'package:hos/veiw/userscreen/screen/home/itemsdetailes.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
import 'package:hos/veiw/userscreen/screen/myfavorite.dart';
import 'package:hos/veiw/userscreen/screen/onboarding/onBoarding.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/viewaddres.dart';

import '../../veiw/userscreen/screen/profile/order/orders.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: '/', page: () => Onboarding(), middlewares: [Midelware()]),

  //Admin=================================================================
  GetPage(name: AdminApproate.adminHome, page: () => AdminHome()),
  GetPage(name: AdminApproate.ViewItemScreen, page: () => ViewItemScreen()),

  //====================================================================

  //=========================================================
  //onBording

  //Homepage
  GetPage(name: Approute.Homescreen, page: () => Homescreen()),
  GetPage(name: Approute.Homepage, page: () => HomePage()),

  GetPage(name: Approute.Items, page: () => Items()),
  GetPage(name: Approute.Itemsdetailes, page: () => Itemsdetailes()),
  GetPage(name: Approute.notificationPage, page: () => NotificationPage()),

  //cart
  GetPage(name: Approute.ShoppingCartPage, page: () => ShoppingCartPage()),
  GetPage(name: Approute.Checkout, page: () => Checkout()),

  //myfavorite
  GetPage(name: Approute.myfavorite, page: () => Myfavorite()),
  GetPage(name: Approute.Orders, page: () => Orders()),

  //Auth
  GetPage(name: Approute.login, page: () => AuthPage()),
  GetPage(name: Approute.veryfisign, page: () => Veryfisign()),
  //Auth//fogetpass
  GetPage(name: Approute.checkemailpage, page: () => ForgetPass()),
  GetPage(name: Approute.Veryficode, page: () => Veryficode()),
  GetPage(name: Approute.Resetpass, page: () => Resetpass()),

  //settings
  GetPage(name: Approute.viewmyaddres, page: () => ViewMyAddres()),
  GetPage(name: Approute.addnewaddres, page: () => AddNewAddres()),
];

class Approute {
  //Homepage
  static String Homescreen = "/Homescreen";
  static String Homepage = "/Homepage";

  static String Items = "/Items";
  static String Itemsdetailes = "/Itemsdetailes";
  static String notificationPage = "/notificationPage";

  //cart
  static String ShoppingCartPage = "/ShoppingCartPage";
  static String Checkout = "/checkout";

  //myfavorite
  static String myfavorite = "/myfavorite";
  static String Orders = "/Orders";

  //Auth
  static String login = "/login";
  static String veryfisign = "/veryfisign";
  //Auth//forgetpass
  static String checkemailpage = "/checkemailpage";
  static String Veryficode = "/Veryficode";
  static String Resetpass = "/Resetpass";
  //onBoarding
  static String Onboarding = "/Onboarding";
  static String language = "/language";

  // settengs
  static String viewmyaddres = "/viewmyaddres";
  static String addnewaddres = "/addnewaddres";
}

class AdminApproate {
  //Admin Home
  static const String adminHome = "/adminHome";
  static const String ViewItemScreen = "/ViewItemScreen";
}
