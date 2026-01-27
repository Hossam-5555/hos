// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:hos/veiw/adminscreen/Home/AdminHome.dart';
import 'package:hos/veiw/driverscreen/driverHome.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/checkout.dart';
import 'package:hos/veiw/userscreen/screen/home/items.dart';
import 'package:hos/core/middilware/midelware.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/forgetpass.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/resetpass.dart';
import 'package:hos/veiw/userscreen/screen/auth/forgetpass/veryficode.dart';
import 'package:hos/veiw/userscreen/screen/auth/login.dart';
import 'package:hos/veiw/userscreen/screen/auth/signup%20.dart';
import 'package:hos/veiw/userscreen/screen/auth/veryfisign.dart';
import 'package:hos/veiw/userscreen/screen/home/homescreen.dart';
import 'package:hos/veiw/userscreen/screen/home/itemsdetailes.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
import 'package:hos/veiw/userscreen/screen/onboarding/language.dart';
import 'package:hos/veiw/userscreen/screen/myfavorite.dart';
import 'package:hos/veiw/userscreen/screen/onboarding/onBoarding.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/viewaddres.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: '/', page: () => Language(), middlewares: [Midelware()]),

  //Admin=================================================================
  GetPage(name: AdminApproate.adminHome, page: () => AdminHome()),
  //====================================================================
  //dreiver
  GetPage(name: AdminApproate.driverHome, page: () => Driverhome()),

  //=========================================================
  //onBording
  GetPage(name: Approute.Onboarding, page: () => Onboarding()),

  //Homepage
  GetPage(name: Approute.Homescreen, page: () => Homescreen()),
  GetPage(name: Approute.Items, page: () => Items()),
  GetPage(name: Approute.Itemsdetailes, page: () => Itemsdetailes()),
    GetPage(name: Approute.notificationPage, page: () => NotificationPage()),

  //cart
  GetPage(name: Approute.ShoppingCartPage, page: () => ShoppingCartPage()),
  GetPage(name: Approute.Checkout, page: () => Checkout()),

  //myfavorite
  GetPage(name: Approute.myfavorite, page: () => Myfavorite()),

  //Auth
  GetPage(name: Approute.login, page: () => Login()),
  GetPage(name: Approute.signup, page: () => Signup()),
  GetPage(name: Approute.veryfisign, page: () => Veryfisign()),
  //Auth//fogetpass
  GetPage(name: Approute.checkemailpage, page: () => forgetpass()),
  GetPage(name: Approute.Veryficode, page: () => Veryficode()),
  GetPage(name: Approute.Resetpass, page: () => Resetpass()),

  //settings
  GetPage(name: Approute.viewmyaddres, page: () => viewmyaddres()),
  GetPage(name: Approute.addnewaddres, page: () => addnewaddres()),
];

class Approute {
  //Homepage
  static String Homescreen = "/Homescreen";
  static String Items = "/Items";
  static String Itemsdetailes = "/Itemsdetailes";
 static String notificationPage = "/notificationPage";

  //cart
  static String ShoppingCartPage = "/ShoppingCartPage";
  static String Checkout = "/checkout";

  //myfavorite
  static String myfavorite = "/myfavorite";

  //Auth
  static String login = "/login";
  static String signup = "/signup";
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
  //deleveryHome
  static const String driverHome = "/driverHome";
}
