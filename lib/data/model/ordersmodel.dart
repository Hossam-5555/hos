class OrderModel {
  final int ordersId;
  final int ordersUsersId;
  final int ordersAddress;
  final int ordersType;
  final int ordersPriceDelivery;
  final int ordersPrice;
  final int ordersTotalPrice;
  final int ordersCoupon;
  final int ordersPaymentMethod;
  final int ordersStatus;
  final String ordersDatetime;

  OrderModel({
    required this.ordersId,
    required this.ordersUsersId,
    required this.ordersAddress,
    required this.ordersType,
    required this.ordersPriceDelivery,
    required this.ordersPrice,
    required this.ordersTotalPrice,
    required this.ordersCoupon,
    required this.ordersPaymentMethod,
    required this.ordersStatus,
    required this.ordersDatetime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      ordersId: json['orders_id'],
      ordersUsersId: json['orders_usersid'],
      ordersAddress: json['orders_address'],
      ordersType: json['orders_type'],
      ordersPriceDelivery: json['orders_pricedelivery'],
      ordersPrice: json['orders_price'],
      ordersTotalPrice: json['orders_totalprice'],
      ordersCoupon: json['orders_coupon'],
      ordersPaymentMethod: json['orders_paymentmethod'],
      ordersStatus: json['orders_status'],
      ordersDatetime: json['orders_datetime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders_id': ordersId,
      'orders_usersid': ordersUsersId,
      'orders_address': ordersAddress,
      'orders_type': ordersType,
      'orders_pricedelivery': ordersPriceDelivery,
      'orders_price': ordersPrice,
      'orders_totalprice': ordersTotalPrice,
      'orders_coupon': ordersCoupon,
      'orders_paymentmethod': ordersPaymentMethod,
      'orders_status': ordersStatus,
      'orders_datetime': ordersDatetime,
    };
  }
}