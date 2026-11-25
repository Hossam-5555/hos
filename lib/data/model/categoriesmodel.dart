

class CategoriesModel {
  int? id;
  String? name;
  String? nameAr;
  String? image;
  String? createdAt;
  int? itemscount;
  CategoriesModel(
      {this.id, this.name, this.nameAr, this.image, this.createdAt,this.itemscount});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    image = json['image'];
    createdAt = json['created_at'];
    itemscount=json["items_count"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['image'] = image;
    data['created_at'] = createdAt;
    data["items_count"]=itemscount;
    return data;
  }
}