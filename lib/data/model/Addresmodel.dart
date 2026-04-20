
class AddresModel {
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

  AddresModel(
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

  AddresModel.fromJson(Map<String, dynamic> json) {
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
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['street'] = this.street;
    data['city'] = this.city;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}