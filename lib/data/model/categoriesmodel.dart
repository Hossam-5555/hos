class categoriesmodel {
  String? categoriesId;
  String? categoriesName;
  String? categoriesNameAr;
  String? categoriesImage;
  String? categoriesDatetime;

  categoriesmodel({
    this.categoriesId,
    this.categoriesName,
    this.categoriesNameAr,
    this.categoriesImage,
    this.categoriesDatetime,
  });

  categoriesmodel.fromJson(Map<String, dynamic> json) {
    categoriesId = json['categories_id']?.toString();   // 👈 هنا
    categoriesName = json['categories_name']?.toString();
    categoriesNameAr = json['categories_name_ar']?.toString();
    categoriesImage = json['categories_image']?.toString();
    categoriesDatetime = json['categories_datetime']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories_id'] = categoriesId;
    data['categories_name'] = categoriesName;
    data['categories_name_ar'] = categoriesNameAr;
    data['categories_image'] = categoriesImage;
    data['categories_datetime'] = categoriesDatetime;
    return data;
  }
}
