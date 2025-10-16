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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      ordersId: json['orders_id']?.toString(),
      ordersUsersid: json['orders_usersid']?.toString(),
      ordersAddress: json['orders_address']?.toString(),
      ordersType: json['orders_type']?.toString(),
      ordersPricedelivery: json['orders_pricedelivery']?.toString(),
      ordersPrice: json['orders_price']?.toString(),
      ordersTotalprice: json['orders_totalprice']?.toString(),
      ordersCoupon: json['orders_coupon']?.toString(),
      ordersPaymentmethod: json['orders_paymentmethod']?.toString(),
      ordersStatus: json['orders_status']?.toString(),
      ordersDatetime: json['orders_datetime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders_id': ordersId,
      'orders_usersid': ordersUsersid,
      'orders_address': ordersAddress,
      'orders_type': ordersType,
      'orders_pricedelivery': ordersPricedelivery,
      'orders_price': ordersPrice,
      'orders_totalprice': ordersTotalprice,
      'orders_coupon': ordersCoupon,
      'orders_paymentmethod': ordersPaymentmethod,
      'orders_status': ordersStatus,
      'orders_datetime': ordersDatetime,
    };
  }
}
