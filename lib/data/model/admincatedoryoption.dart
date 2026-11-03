// المسار المقترح: lib/data/model/admincategoryoption.dart

/// قسم بسيط بيظهر كـ chip في فورم البراند (id + الاسم بالعربي والإنجليزي).
class AdminCategoryOption {
  final int id;
  final String name;
  final String nameAr;

  const AdminCategoryOption({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  static String _first(Map<String, dynamic> json, List<String> keys) {
    for (final k in keys) {
      final v = json[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return '';
  }

  // TODO: لو أسماء أعمدة جدول categories عندك مختلفة، ضيفها في القوائم دي.
  // لو الاسم ظهر "#3" بدل اسم القسم يبقى مفتاح الاسم مش موجود هنا.
  factory AdminCategoryOption.fromJson(Map<String, dynamic> json) {
    final id =
        int.tryParse(_first(json, ['id', 'categories_id', 'category_id'])) ?? 0;

    final name = _first(json, [
      'name',
      'categories_name',
      'category_name',
      'title',
    ]);

    final nameAr = _first(json, [
      'name_ar',
      'categories_name_ar',
      'category_name_ar',
      'title_ar',
    ]);

    return AdminCategoryOption(
      id: id,
      name: name.isNotEmpty ? name : nameAr,
      nameAr: nameAr.isNotEmpty ? nameAr : name,
    );
  }

  String label(bool isArabic) {
    final t = isArabic ? nameAr : name;
    return t.isEmpty ? '#$id' : t;
  }
}