class ItemsModel {
  int? id;
  String? itemsName;
  String? itemsNameAr;
  String? itemsDesc;
  String? itemsDescAr;
  String? itemsImage;
  List<String>? images;
  int? itemsDiscount;
  int? stock;
  int? itemsActive;
  int? itemsPrice;
  int? categoryId;
  String? categoryName;
  String? categoryNameAr;
  var priceAfterDiscount;
  bool? isFavorite;

  ItemsModel({
    this.id,
    this.itemsName,
    this.itemsNameAr,
    this.itemsDesc,
    this.itemsDescAr,
    this.itemsImage,
    this.images,
    this.itemsDiscount,
    this.stock,
    this.itemsActive,
    this.itemsPrice,
    this.categoryId,
    this.categoryName,
    this.categoryNameAr,
    this.priceAfterDiscount,
    this.isFavorite,
  });

  ItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemsName = json['items_name'];
    itemsNameAr = json['items_name_ar'];
    itemsDesc = json['items_desc'];
    itemsDescAr = json['items_desc_ar'];
    itemsImage = json['items_image'];
    images = json['images'].cast<String>();
    itemsDiscount = json['items_discount'];
    stock = json['stock'];
    itemsActive = json['items_active'];
    itemsPrice = json['items_price'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryNameAr = json['category_name_ar'];
    priceAfterDiscount = json['price_after_discount'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['items_name'] = this.itemsName;
    data['items_name_ar'] = this.itemsNameAr;
    data['items_desc'] = this.itemsDesc;
    data['items_desc_ar'] = this.itemsDescAr;
    data['items_image'] = this.itemsImage;
    data['images'] = this.images;
    data['items_discount'] = this.itemsDiscount;
    data['stock'] = this.stock;
    data['items_active'] = this.itemsActive;
    data['items_price'] = this.itemsPrice;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_name_ar'] = this.categoryNameAr;
    data['price_after_discount'] = this.priceAfterDiscount;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}

class Brandmodel {
  int? id;
  String? name;
  Brandmodel({this.id, this.name});
  Brandmodel.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;

    return data;
  }
}
