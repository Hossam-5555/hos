

class CategoriesModel {
  int? id;
  String? name;
  String? nameAr;
  String? image;
  String? createdAt;

  CategoriesModel(
      {this.id, this.name, this.nameAr, this.image, this.createdAt});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['image'] = image;
    data['created_at'] = createdAt;
    return data;
  }
}