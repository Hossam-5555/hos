class LinkApi {
  static String server = 'http://10.0.2.2/ecommerce';
  static String linktest = "$server/test.php";
  //imagelink=============================
  static String imagelink = 'http://10.0.2.2/ecommerce/upload';
  static String imagecategories = '$imagelink/categories';
  static String imageitems = '$imagelink/items';

  //Auth=============================
  static String Signup = '$server/auth/signup.php';
  static String login = '$server/auth/login.php';
  static String veryfisign = '$server/auth/veryfi.php';
  static String resend = '$server/auth/resend.php';

  //forgetpassword====================
  static String checkemail = '$server/forgetpassword/checkemail.php';
  static String resetpass = '$server/forgetpassword/resetpass.php';
  static String veryfycodeforgetpass = '$server/forgetpassword/verifycode.php';
  //Home
  static String homepage = '$server/home.php';

  // items
  static String items = '$server/items/items.php';
  static String search = '$server//items/search.php';

  //favorite
  static String addfav = '$server/favorite/add.php';
  static String remove = '$server/favorite/remove.php';
  static String view = '$server/favorite/view.php';
  static String deletefromfavorite = '$server/favorite/deletefromfavroite.php';
  //cart
  static String addcart = '$server/cart/add.php';
  static String deletcart = '$server/cart/delete.php';
  static String viewcart = '$server/cart/view.php';
  static String getcount = '$server/cart/getcountitems.php';
  static String coupone = '$server/coupone/chechcoupone.php';
  // AddresLink
  static String AddAddres = '$server/address/add.php';
  static String deleteAddres = '$server/address/delete.php';
  static String viewAddres = '$server/address/view.php';
  static String editAddres = '$server/address/edit.php';
  //orders
  static String checkout = '$server/orders/add.php';
  static String viewmyorder = '$server/orders/vieworders.php';
  static String orderdetails = '$server/orders/ordersdetails.php';
  static String deleteorder = '$server/orders/delete.php';

  //notification
  static String notification = '$server/notification.php';
}
