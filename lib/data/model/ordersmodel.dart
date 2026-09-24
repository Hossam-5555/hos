import 'package:hos/data/model/addres_model.dart';

class OrderModel {
  final int orderId;
  final String username;
  final int userId;
  final String orderNumber;
  final double subtotal;
  final double taxAmount;
  final double shippingFee;
  final double totalAmount;
   String status;
  final String paymentStatus;
  final String paymentMethod;
  final String createdAt;
  final List<OrderItemmodel> items;
  final AddressModel shippingAddress;

  OrderModel({
    required this.orderId,
    required this.username,
    required this.userId,
    required this.orderNumber,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingFee,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
    required this.shippingAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      username: json['username'],
      userId: json['user_id'],
      orderNumber: json['order_number'],
      subtotal: (json['subtotal'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      shippingFee: (json['shipping_fee'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
      createdAt: json['created_at'],

      // 🔥 تحويل الليست
      items: List<OrderItemmodel>.from(
        json['items'].map((e) => OrderItemmodel.fromJson(e)),
      ),

      // 🔥 تحويل العنوان
      shippingAddress: AddressModel.fromJson(json['shipping_address']),
    );
  }
}

class OrderItemmodel {
  int? orderId;
  int? productId;
  String? productName;
  int? quantity;
  int? price;
  int? totalPrice;
  String? image;

  OrderItemmodel({
    this.orderId,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.totalPrice,
     this.image,
  });

  OrderItemmodel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data["image"] = image;
    return data;
  }
}
