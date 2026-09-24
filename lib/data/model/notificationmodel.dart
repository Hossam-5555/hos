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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['user_id'] = userId;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    return data;
  }
}