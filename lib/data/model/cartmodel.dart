class cartmodel {
  String? totalprice;
  int? countofitem;
  int? cartId;
  int? cartUserid;
  int? cartItemid;
  int? cartCount;
  int? itemsId;
  String? itemsName;
  String? itemsNameAr;
  String? itemsDesc;
  String? itemsDescAr;
  String? itemsImage;
  int? itemsCount;
  int? itemsActive;
  String? itemsPrice;
  String? itemsDiscount;
  String? itemsDate;
  int? itemsCat;

  cartmodel(
      {this.totalprice,
      this.countofitem,
      this.cartId,
      this.cartUserid,
      this.cartItemid,
      this.cartCount,
      this.itemsId,
      this.itemsName,
      this.itemsNameAr,
      this.itemsDesc,
      this.itemsDescAr,
      this.itemsImage,
      this.itemsCount,
      this.itemsActive,
      this.itemsPrice,
      this.itemsDiscount,
      this.itemsDate,
      this.itemsCat});

  cartmodel.fromJson(Map<String, dynamic> json) {
    totalprice = json['totalprice'];
    countofitem = json['countofitem'];
    cartId = json['cart_id'];
    cartUserid = json['cart_userid'];
    cartItemid = json['cart_itemid'];
    cartCount = json['cart_count'];
    itemsId = json['items_id'];
    itemsName = json['items_name'];
    itemsNameAr = json['items_name_ar'];
    itemsDesc = json['items_desc'];
    itemsDescAr = json['items_desc_ar'];
    itemsImage = json['items_image'];
    itemsCount = json['items_count'];
    itemsActive = json['items_active'];
    itemsPrice = json['items_price'];
    itemsDiscount = json['items_discount'];
    itemsDate = json['items_date'];
    itemsCat = json['items_cat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalprice'] = this.totalprice;
    data['countofitem'] = this.countofitem;
    data['cart_id'] = this.cartId;
    data['cart_userid'] = this.cartUserid;
    data['cart_itemid'] = this.cartItemid;
    data['cart_count'] = this.cartCount;
    data['items_id'] = this.itemsId;
    data['items_name'] = this.itemsName;
    data['items_name_ar'] = this.itemsNameAr;
    data['items_desc'] = this.itemsDesc;
    data['items_desc_ar'] = this.itemsDescAr;
    data['items_image'] = this.itemsImage;
    data['items_count'] = this.itemsCount;
    data['items_active'] = this.itemsActive;
    data['items_price'] = this.itemsPrice;
    data['items_discount'] = this.itemsDiscount;
    data['items_date'] = this.itemsDate;
    data['items_cat'] = this.itemsCat;
    return data;
  }
}


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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['itemid'] = this.itemid;
    data['itemsname'] = this.itemsname;
    data['itemsprice'] = this.itemsprice;
    data['cart_count'] = this.cartCount;
    data['subtotal'] = this.subtotal;
    data['item_image'] = this.itemimage;
    data['created_at'] = this.createdAt;
    return data;
  }
}