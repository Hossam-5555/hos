class Itemsmodel {
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
  String? itemspricediscount;
  int? categoriesId;
  String? categoriesName;
  String? categoriesNameAr;
  String? categoriesImage;
  String? categoriesDatetime;
  String? favorite;

  Itemsmodel({
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
    this.itemsCat,
    this.itemspricediscount,
    this.categoriesId,
    this.categoriesName,
    this.categoriesNameAr,
    this.categoriesImage,
    this.categoriesDatetime,
    this.favorite,
  });

  Itemsmodel.fromJson(Map<String, dynamic> json) {
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
    itemspricediscount = json['itemspricediscount'];
    favorite = json["favorite"].toString();
    categoriesId = json['categories_id'];
    categoriesName = json['categories_name'];
    categoriesNameAr = json['categories_name_ar'];
    categoriesImage = json['categories_image'];
    categoriesDatetime = json['categories_datetime'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['items_id'] = this.itemsId;
  //   data['items_name'] = this.itemsName;
  //   data['items_name_ar'] = this.itemsNameAr;
  //   data['items_desc'] = this.itemsDesc;
  //   data['items_desc_ar'] = this.itemsDescAr;
  //   data['items_image'] = this.itemsImage;
  //   data['items_count'] = this.itemsCount;
  //   data['items_active'] = this.itemsActive;
  //   data['items_price'] = this.itemsPrice;
  //   data['items_discount'] = this.itemsDiscount;
  //   data['items_date'] = this.itemsDate;
  //   data['items_cat'] = this.itemsCat;
  //   data['categories_id'] = this.categoriesId;
  //   data['categories_name'] = this.categoriesName;
  //   data['categories_name_ar'] = this.categoriesNameAr;
  //   data['categories_image'] = this.categoriesImage;
  //   data['categories_datetime'] = this.categoriesDatetime;
  //   return data;
  // }
}
class ItemsModel1 {
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
  int? priceAfterDiscount;
  bool? isFavorite;

  ItemsModel1(
      {this.id,
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
      this.isFavorite});

  ItemsModel1.fromJson(Map<String, dynamic> json) {
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