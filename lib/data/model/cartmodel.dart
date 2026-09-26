
class CartModel {
  int? userid;
  String? username;
  int? itemid;
  String? itemsname;
  int? itemsprice;
  int? cartCount;
  int? subtotal;
  String? itemimage;
  String? createdAt;

  CartModel(
      {this.userid,
      this.username,
      this.itemid,
      this.itemsname,
      this.itemsprice,
      this.cartCount,
      this.subtotal,
      this.itemimage,
      this.createdAt});

  CartModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    itemid = json['itemid'];
    itemsname = json['itemsname'];
    itemsprice = json['itemsprice'];
    cartCount = json['cart_count'];
    subtotal = json['subtotal'];
    itemimage = json['item_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['username'] = username;
    data['itemid'] = itemid;
    data['itemsname'] = itemsname;
    data['itemsprice'] = itemsprice;
    data['cart_count'] = cartCount;
    data['subtotal'] = subtotal;
    data['item_image'] = itemimage;
    data['created_at'] = createdAt;
    return data;
  }
}