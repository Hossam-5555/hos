
class AddressModel {
  int? id;
  int? userId;
  String? name;
  String? street;
  String? city;
  double? lat;
  double? lng;
  String? phone;
  String? createdAt;
  String? updatedAt;

  AddressModel(
      {this.id,
      this.userId,
      this.name,
      this.street,
      this.city,
      this.lat,
      this.lng,
      this.phone,
      this.createdAt,
      this.updatedAt});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    street = json['street'];
    city = json['city'];
    lat = json['lat'];
    lng = json['lng'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['street'] = street;
    data['city'] = city;
    data['lat'] = lat;
    data['lng'] = lng;
    data['phone'] = phone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}