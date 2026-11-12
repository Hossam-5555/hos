// المسار المقترح: lib/data/model/adminbrandmodel.dart

class AdminBrandModel {
  final int id;
  final String name;

  /// عدد المنتجات المربوطة بالبراند (من withCount في الباك إند)
  final int itemsCount;

  /// عدد الأقسام المربوطة بالبراند
  final int categoriesCount;

  /// ids الأقسام المربوطة (بتتعبّى منها الأقسام المختارة في فورم التعديل)
  final List<int> categoryIds;

  const AdminBrandModel({
    required this.id,
    required this.name,
    this.itemsCount = 0,
    this.categoriesCount = 0,
    this.categoryIds = const [],
  });

  static int _i(dynamic v) => int.tryParse('$v') ?? 0;

  factory AdminBrandModel.fromJson(Map<String, dynamic> json) {
    return AdminBrandModel(
      id: _i(json['id']),
      name: (json['name'] ?? '').toString(),
      itemsCount: _i(json['items_count']),
      categoriesCount: _i(json['categories_count']),
      categoryIds: ((json['category_ids'] as List?) ?? const [])
          .map((e) => _i(e))
          .toList(),
    );
  }

  /// البراند مربوط بمنتجات، والباك إند هيرفض حذفه
  bool get isInUse => itemsCount > 0;
}


