class OrderModel {
  String? ordersId;
  String? ordersUsersid;
  String? ordersAddress;
  String? ordersType;
  String? ordersPricedelivery;
  String? ordersPrice;
  String? ordersTotalprice;
  String? ordersCoupon;
  String? ordersPaymentmethod;
  String? ordersStatus;
  String? ordersDatetime;
  String? addresId;
  String? addresUserid;
  String? addresName;
  String? addresCity;
  String? addresStreet;
  double? addresLat;
  double? addresLang;
  String? rating;
  String? comment;

  OrderModel({
    this.ordersId,
    this.ordersUsersid,
    this.ordersAddress,
    this.ordersType,
    this.ordersPricedelivery,
    this.ordersPrice,
    this.ordersTotalprice,
    this.ordersCoupon,
    this.ordersPaymentmethod,
    this.ordersStatus,
    this.ordersDatetime,
    this.addresId,
    this.addresUserid,
    this.addresName,
    this.addresCity,
    this.addresStreet,
    this.addresLat,
    this.addresLang,
    this.rating,
    this.comment,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    ordersId = json['orders_id'].toString();
    ordersUsersid = json['orders_usersid'].toString();
    ordersAddress = json['orders_address'].toString();
    ordersType = json['orders_type'].toString();
    ordersPricedelivery = json['orders_pricedelivery'].toString();
    ordersPrice = json['orders_price'].toString();
    ordersTotalprice = json['orders_totalprice'].toString();
    ordersCoupon = json['orders_coupon'].toString();
    ordersPaymentmethod = json['orders_paymentmethod'].toString();
    ordersStatus = json['orders_status'].toString();
    ordersDatetime = json['orders_datetime'].toString();
    addresId = json['addres_id'].toString();
    addresUserid = json['addres_userid'].toString();
    addresName = json['addres_name'].toString();
    addresCity = json['addres_city'].toString();
    addresStreet = json['addres_street'].toString();
    addresLat = json['addres_lat'];
    addresLang = json['addres_lang'];
    rating = json['order_rating'].toString();
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orders_id'] = this.ordersId;
    data['orders_usersid'] = this.ordersUsersid;
    data['orders_address'] = this.ordersAddress;
    data['orders_type'] = this.ordersType;
    data['orders_pricedelivery'] = this.ordersPricedelivery;
    data['orders_price'] = this.ordersPrice;
    data['orders_totalprice'] = this.ordersTotalprice;
    data['orders_coupon'] = this.ordersCoupon;
    data['orders_paymentmethod'] = this.ordersPaymentmethod;
    data['orders_status'] = this.ordersStatus;
    data['orders_datetime'] = this.ordersDatetime;
    data['addres_id'] = this.addresId;
    data['addres_userid'] = this.addresUserid;
    data['addres_name'] = this.addresName;
    data['addres_city'] = this.addresCity;
    data['addres_street'] = this.addresStreet;
    data['addres_lat'] = this.addresLat;
    data['addres_lang'] = this.addresLang;
    return data;
  }
}
