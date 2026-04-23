class UserModel {
  int? id;
  String? name;
  String? usersType;
  String? email;
  Null emailVerifiedAt;
  int? isAprove;
  String? createdAt;
  String? updatedAt;
  String? verificationCode;

  UserModel(
      {this.id,
      this.name,
      this.usersType,
      this.email,
      this.emailVerifiedAt,
      this.isAprove,
      this.createdAt,
      this.updatedAt,
      this.verificationCode});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    usersType = json['users_type'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    isAprove = json['is_aprove'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    verificationCode = json['verification_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['users_type'] = this.usersType;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['is_aprove'] = this.isAprove;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['verification_code'] = this.verificationCode;
    return data;
  }
}