class LinkApi {
  // static String lravelserver = "http://192.168.1.8/api";
  static String lravelserver = "http://10.0.2.2:8000/api";
  //imagelink=============================

  //Auth=============================
  static String signup = '$lravelserver/register';
  static String login = '$lravelserver/login';
  static String veryfisign = '$lravelserver/verify';
  static String resend = '$lravelserver/resend';

  //forgetpassword====================
  static String checkemail = '$lravelserver/forgot-password';
  static String resetpass = '$lravelserver/resetPassword';
  static String veryfycodeforgetpass = '$lravelserver/verifyresetpass';
  //Home
  static String homepage = '$lravelserver/Home';

  // items
  static String items = '$lravelserver/Getitems';
  static String search = '$lravelserver/search';

  //favorite

  static String view = '$lravelserver/getfavorite';
  static String favoritemanger = '$lravelserver/favoritemanger';
  //cart
  static String cart = '$lravelserver/cart';
  static String deletcart = '$lravelserver/decrease';
  // static String coupone = '$server/coupone/chechcoupone.php';
  // AddresLink
  static String addaddres = '$lravelserver/Address';
  static String deleteAddres = '$lravelserver/delelteaddres';
    static String setdafault = '$lravelserver/defaultaddress';

  //orders
  static String order = '$lravelserver/order';
  static String viewmyorder = '$lravelserver/userorders';
  // static String rating = '$server/rating.php';

  //notification
  static String notification = '$lravelserver/massage';
  static String deletnotification = '$lravelserver/deleltemassage';

  //offer
  static String offer = '$lravelserver/offer';

  //Admin //categores
  static String dashborddata="$lravelserver/dashboadcontroller";
  static String admincategrory = '$lravelserver/category';
  static String admindeletecat = '$lravelserver/deletecategory';
  //Admin //items
  static String cruditemsadmin = '$lravelserver/items';
  static String adminviewitem = '$lravelserver/category';

 
}
