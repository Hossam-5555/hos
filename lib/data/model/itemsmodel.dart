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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['items_name'] = itemsName;
    data['items_name_ar'] = itemsNameAr;
    data['items_desc'] = itemsDesc;
    data['items_desc_ar'] = itemsDescAr;
    data['items_image'] = itemsImage;
    data['images'] = images;
    data['items_discount'] = itemsDiscount;
    data['stock'] = stock;
    data['items_active'] = itemsActive;
    data['items_price'] = itemsPrice;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['category_name_ar'] = categoryNameAr;
    data['price_after_discount'] = priceAfterDiscount;
    data['is_favorite'] = isFavorite;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}
