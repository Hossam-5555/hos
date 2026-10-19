// المسار المقترح: lib/data/model/adminbrandmodel.dart

class AdminBrandModel {
  final int id;
  final String name;

  /// عدد المنتجات المربوطة بالبراند (من withCount في الباك إند)
  final int itemsCount;

  /// عدد الأقسام المربوطة بالبراند
  final int categoriesCount;

  const AdminBrandModel({
    required this.id,
    required this.name,
    this.itemsCount = 0,
    this.categoriesCount = 0,
  });

  static int _i(dynamic v) => int.tryParse('$v') ?? 0;

  factory AdminBrandModel.fromJson(Map<String, dynamic> json) {
    return AdminBrandModel(
      id: _i(json['id']),
      name: (json['name'] ?? '').toString(),
      itemsCount: _i(json['items_count']),
      categoriesCount: _i(json['categories_count']),
    );
  }

  /// البراند مربوط بمنتجات، والباك إند هيرفض حذفه
  bool get isInUse => itemsCount > 0;
}