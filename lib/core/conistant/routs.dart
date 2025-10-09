import 'package:get/get.dart';
import 'package:hos/veiw/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/screen/cartandcheckout/checkout.dart';
import 'package:hos/veiw/screen/home/items.dart';
import 'package:hos/core/middilware/midelware.dart';
import 'package:hos/veiw/screen/auth/forgetpass/forgetpass.dart';
import 'package:hos/veiw/screen/auth/forgetpass/resetpass.dart';
import 'package:hos/veiw/screen/auth/forgetpass/succesresetpass.dart';
import 'package:hos/veiw/screen/auth/forgetpass/veryficode.dart';
import 'package:hos/veiw/screen/auth/login.dart';
import 'package:hos/veiw/screen/auth/signup%20.dart';
import 'package:hos/veiw/screen/auth/successignup.dart';
import 'package:hos/veiw/screen/auth/veryfisign.dart';
import 'package:hos/veiw/screen/home/homescreen.dart';
import 'package:hos/veiw/screen/home/itemsdetailes.dart';
import 'package:hos/veiw/screen/onboarding/language.dart';
import 'package:hos/veiw/screen/myfavorite.dart';
import 'package:hos/veiw/screen/onboarding/onBoarding.dart';
import 'package:hos/veiw/screen/settings/addres/add.dart';
import 'package:hos/veiw/screen/settings/addres/viewaddres.dart';

List<GetPage<dynamic>>? routes = [
  //Homepage
  GetPage(name: Approute.Homescreen, page: () => Homescreen()),
  GetPage(name: Approute.Items, page: () => Items()),
  GetPage(name: Approute.Itemsdetailes, page: () => Itemsdetailes()),
  //cart
  GetPage(name: Approute.ShoppingCartPage, page: () => ShoppingCartPage()),
  GetPage(name: Approute.Checkout, page: () => Checkout()),

  //myfavorite
  GetPage(name: Approute.myfavorite, page: () => Myfavorite()),

  //onBording
  GetPage(name: '/', page: () => Language(), middlewares: [Midelware()]),
  GetPage(name: Approute.Onboarding, page: () => Onboarding()),

  //Auth
  GetPage(name: Approute.login, page: () => Login()),
  GetPage(name: Approute.signup, page: () => Signup()),
  GetPage(name: Approute.Successignup, page: () => Successignup()),
  GetPage(name: Approute.veryfisign, page: () => Veryfisign()),
  //Auth//fogetpass
  GetPage(name: Approute.checkemailpage, page: () => forgetpass()),
  GetPage(name: Approute.Veryficode, page: () => Veryficode()),
  GetPage(name: Approute.Resetpass, page: () => Resetpass()),
  GetPage(name: Approute.Succesresetpass, page: () => Succesresetpass()),

  //settings
  GetPage(name: Approute.viewmyaddres, page: () => viewmyaddres()),
  GetPage(name: Approute.addnewaddres, page: () => addnewaddres()),
];

class Approute {
  //Homepage
  static String Homescreen = "/Homescreen";
  static String Items = "/Items";
  static String Itemsdetailes = "/Itemsdetailes";
  //cart
  static String ShoppingCartPage = "/ShoppingCartPage";
  static String Checkout = "/checkout";

  //myfavorite
  static String myfavorite = "/myfavorite";

  //Auth
  static String login = "/login";
  static String signup = "/signup";
  static String Successignup = "/Successignup";
  static String veryfisign = "/veryfisign";
  //Auth//forgetpass
  static String checkemailpage = "/checkemailpage";
  static String Veryficode = "/Veryficode";
  static String Resetpass = "/Resetpass";
  static String Succesresetpass = "/Succesresetpass";
  //onBoarding
  static String Onboarding = "/Onboarding";
  static String language = "/language";

  // settengs
  static String viewmyaddres = "/viewmyaddres";
  static String addnewaddres = "/addnewaddres";
}
