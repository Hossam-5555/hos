import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CategoryItem {
  final int id;
  final String name;
  final IconData icon;
  CategoryItem({required this.id, required this.name, required this.icon});
}

class BrandItem {
  final int id;
  final String name;
  final String imageUrl;
  final int categoryId;
  BrandItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryId,
  });
}

class FilterController extends GetxController {
  final double defaultMin = 0.0;
  final double defaultMax = 5000.0;

  var minPrice = 0.0.obs;
  var maxPrice = 5000.0.obs;
  var selectedSort = "newest".obs;
  var selectedBrands = <int>[].obs;
  var selectedCategory = 0.obs;

  final categories = [
    CategoryItem(id: 0, name: "All", icon: Icons.grid_view_rounded),
    CategoryItem(id: 1, name: "Electronics", icon: Icons.phone_android_rounded),
    CategoryItem(id: 2, name: "Fashion", icon: Icons.checkroom_rounded),
    CategoryItem(id: 3, name: "Home", icon: Icons.chair_rounded),
  ];

final allBrands = [
  // Electronics
  BrandItem(
    id: 1,
    name: "Apple",
    categoryId: 1,
    imageUrl: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-drip-field-7.png",
  ),
  BrandItem(
    id: 2,
    name: "Samsung",
    categoryId: 1,
    imageUrl: "https://www.freepnglogos.com/uploads/samsung-logo-text-png-1.png",
  ),
  BrandItem(
    id: 3,
    name: "Sony",
    categoryId: 1,
    imageUrl: "https://www.freepnglogos.com/uploads/sony-logo-png-0.png",
  ),
  
  // Fashion
  BrandItem(
    id: 4,
    name: "Nike",
    categoryId: 2,
    imageUrl: "https://www.freepnglogos.com/uploads/nike-logo-png/nike-logo-black-transparent-svg-png-24.png",
  ),
  BrandItem(
    id: 5,
    name: "Adidas",
    categoryId: 2,
    imageUrl: "https://www.freepnglogos.com/uploads/adidas-logo-png-hd-2.png",
  ),
  BrandItem(
    id: 6,
    name: "Zara",
    categoryId: 2,
    imageUrl: "https://brandlogos.net/wp-content/uploads/2021/11/zara-logo.png",
  ),

  // Home
  BrandItem(
    id: 7,
    name: "IKEA",
    categoryId: 3,
    imageUrl: "https://brandlogos.net/wp-content/uploads/2012/10/ikea-logo-vector.png",
  ),
];

  // دالة الفلترة تعتمد على selectedCategory.value مما يجعلها مراقبة
  List<BrandItem> get filteredBrands {
    if (selectedCategory.value == 0) return allBrands;
    return allBrands
        .where((brand) => brand.categoryId == selectedCategory.value)
        .toList();
  }

  int get activeFiltersCount {
    int count = 0;
    if (minPrice.value != defaultMin || maxPrice.value != defaultMax) count++;
    if (selectedSort.value != "newest") count++;
    if (selectedBrands.isNotEmpty) count++;
    if (selectedCategory.value != 0) count++;
    return count;
  }

  Map<String, dynamic> get filterParams => {
    "category_id": selectedCategory.value == 0 ? null : selectedCategory.value,
    "min_price": minPrice.value.round(),
    "max_price": maxPrice.value.round(),
    "sort_by": selectedSort.value,
    "brands": selectedBrands.toList(),
  };

  void toggleBrand(int brandId) {
    if (selectedBrands.contains(brandId)) {
      selectedBrands.remove(brandId);
    } else {
      selectedBrands.add(brandId);
    }
  }

  void selectCategory(int categoryId) {
    selectedCategory.value = categoryId;
    selectedBrands.clear();
  }

  void reset() {
    minPrice.value = defaultMin;
    maxPrice.value = defaultMax;
    selectedSort.value = "newest";
    selectedBrands.clear();
    selectedCategory.value = 0;
  }
}