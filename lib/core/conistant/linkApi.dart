class LinkApi {
  static String server = 'http://10.0.2.2/ecommerce';
  // static String server = "http://192.168.1.8/ecommerce";
  static String lravelserver = "http://10.0.2.2:8000/api";
  //imagelink=============================
  static String imagelink = 'http://10.0.2.2/ecommerce/upload';
  // static String imagelink = 'http://192.168.1.8/ecommerce/upload';

  static String imagecategories = '$imagelink/categories';
  static String imageitems = '$imagelink/items';

  //Auth=============================
  static String signup = '$lravelserver/register';
  static String login = '$lravelserver/login';
  static String veryfisign = '$lravelserver/verify';
  static String resend = '$server/auth/resend.php';

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
  static String addcart = '$lravelserver/cart';
  static String deletcart = '$lravelserver/decrease';
  static String viewcart = '$lravelserver/cart/';
  static String coupone = '$server/coupone/chechcoupone.php';
  // AddresLink
  static String addaddres = '$lravelserver/Address';
  static String deleteAddres = '$lravelserver/delelteaddres';
  static String viewAddres = '$lravelserver/Address/';
  static String editAddres = '$server/address/edit.php';
  //orders
  static String checkout = '$lravelserver/order';
  static String viewmyorder = '$lravelserver/userorders/';
  static String deleteorder = '$server/orders/delete.php';
  static String rating = '$server/rating.php';

  //notification
  static String notification = '$lravelserver/getmassage';
  static String deletnotification = '$lravelserver/deleltemassage';

  //offer
  static String offer = '$lravelserver/offer';

  // driver
  static String driverpendingorder = '$server/driver/orders/pending.php';
  static String driveraccebtedorder = '$server/driver/orders/accepted.php';
  static String driverarchiveorder = '$server/driver/orders/archive.php';
  static String driverorderdetails = '$server/driver/orders/details.php';
  static String driverapproveorder = '$server/driver/orders/approve.php';
  static String driverdoneorder = '$server/driver/orders/done.php';

  //Admin //categores
  static String adminaddcat = '$server/admin/categories/add.php';
  static String admineditcat = '$server/admin/categories/edit.php';
  static String adminviewcat = '$server/admin/categories/view.php';
  static String admindeletecat = '$server/admin/categories/delete.php';
  //Admin //items
  static String adminadditem = '$server/admin/items/add.php';
  static String adminviewitem = '$server/admin/items/view.php';
  static String adminedititem = '$server/admin/items/edit.php';
  static String admindeleteitems = '$server/admin/items/delete.php';

  //Admin//orders
  static String adminorderpending = '$server/admin/orders/pending.php';
  static String adminorderaccepted = '$server/admin/orders/accepted.php';
  static String adminorderdetails = '$server/admin/orders/details.php';
  static String adminaprovedorder = '$server/admin/orders/approve.php';
  static String prepareorder = '$server/admin/orders/prepare.php';
}
