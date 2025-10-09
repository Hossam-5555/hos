class Addresmodel {
  int? addresId;
  int? addresUserid;
  String? addresName;
  String? addresCity;
  String? addresStreet;
  double? addresLat;
  double? addresLang;

  Addresmodel(
      {this.addresId,
      this.addresUserid,
      this.addresName,
      this.addresCity,
      this.addresStreet,
      this.addresLat,
      this.addresLang});

  Addresmodel.fromJson(Map<String, dynamic> json) {
    addresId = json['addres_id'];
    addresUserid = json['addres_userid'];
    addresName = json['addres_name'];
    addresCity = json['addres_city'];
    addresStreet = json['addres_street'];
    addresLat = json['addres_lat'];
    addresLang = json['addres_lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addres_id'] = this.addresId;
    data['addres_userid'] = this.addresUserid;
    data['addres_name'] = this.addresName;
    data['addres_city'] = this.addresCity;
    data['addres_street'] = this.addresStreet;
    data['addres_lat'] = this.addresLat;
    data['addres_lang'] = this.addresLang;
    return data;
  }
}