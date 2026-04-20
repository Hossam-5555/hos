import 'package:hos/data/model/itemsmodel.dart';

class favoriteModel {
  int? id;
  int? userId;
  ItemsModel? item; // استخدام الموديل الموجود عندك
  String? createdAt;

  favoriteModel({this.id, this.userId, this.item, this.createdAt});

  favoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    // هنا نقوم بتحويل الجزء الخاص بالمنتج باستخدام الموديل الجاهز لديك
    item = json['item'] != null ? ItemsModel.fromJson(json['item']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    if (item != null) {
      data['item'] = item!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}
