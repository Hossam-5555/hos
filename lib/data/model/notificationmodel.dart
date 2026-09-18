class MessageModel {
  int? id;
  String? title;
  String? body;
  int? userId;
  bool? isActive;
  String? createdAt;

  MessageModel(
      {this.id,
      this.title,
      this.body,
      this.userId,
      this.isActive,
      this.createdAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    userId = json['user_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['user_id'] = this.userId;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    return data;
  }
}