import 'package:flutter/material.dart';
import 'package:get/get.dart';
// تأكد من مسار الكنترولر الخاص بك
import 'package:hos/controler/usercontroller/home/items_controler.dart';

void showFilterDialog(BuildContext context, ItemsController c) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        // هنا السر: الـ insetPadding هو المسؤول عن عمل مارجن من كل الجهات
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        backgroundColor:
            Colors.transparent, // شفافة عشان نتحكم في شكل الـ Container الداخلي
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(28), // حواف دائرية لكل النافذة
          ),
          child: Column(
            children: [
              _buildHandle(Theme.of(context)), // المقبض العلوي
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildHeader(context, c),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, "Sort By"),
                    _buildSortOptions(c, Theme.of(context)),
                    const SizedBox(height: 28),
                    _buildSectionTitle(context, "Price Range"),
                    _buildPriceSlider(context, c),
                    const SizedBox(height: 28),
                    _buildSectionTitle(context, "Brands"),
                    _buildBrandImages(context, c),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _buildBottomButtons(context, c), // زر التطبيق
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildSectionTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  );
}

Widget _buildHeader(BuildContext context, ItemsController c) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Advanced Filter",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      Obx(() {
        // استدعاء القيمة داخل الـ Obx لضمان التحديث
        if (c.activeFiltersCount > 0) {
          return TextButton(
            onPressed: c.reset,
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text("Reset All"),
          );
        }
        return const SizedBox.shrink();
      }),
    ],
  );
}

Widget _buildSortOptions(ItemsController c, ThemeData theme) {
  final sortOptions = {
    "newest": {"label": "Newest", "icon": Icons.access_time_rounded},
    "oldest": {"label": "Oldest", "icon": Icons.history_rounded},
    "price_low": {"label": "Lowest Price", "icon": Icons.trending_down_rounded},
    "price_high": {"label": "Highest Price", "icon": Icons.trending_up_rounded},
  };

  return Obx(() {
    final currentSort = c.selectedSort.value;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.7,
      ),
      itemCount: sortOptions.length,
      itemBuilder: (context, index) {
        String key = sortOptions.keys.elementAt(index);
        var option = sortOptions[key]!;

        bool isSelected = currentSort == key;

        return GestureDetector(
          onTap: () => c.selectedSort.value = key,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              // لون داكن هادئ للعنصر غير المحدد، ولون مميز للمحدد
              color: isSelected
                  ? Colors.blue.withOpacity(0.15)
                  : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.white12,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  option["icon"] as IconData,
                  size: 18,
                  color: isSelected ? Colors.blueAccent : Colors.white54,
                ),
                const SizedBox(width: 8),
                Text(
                  option["label"] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.blueAccent : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}

Widget _buildPriceSlider(BuildContext context, ItemsController c) {
  return Obx(
    () => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _priceContainer(context, "Min", c.minPrice.value),
            _priceContainer(context, "Max", c.maxPrice.value),
          ],
        ),
        RangeSlider(
          values: RangeValues(c.minPrice.value, c.maxPrice.value),
          min: c
              .defaultMin, // تأكد إن دي RxDouble في الكنترولر أو غيرها لـ double عادي
          max: c.defaultMax,
          divisions: 50,
          activeColor: Colors.blueAccent,
          inactiveColor: Colors.white12,
          onChanged: (v) {
            c.minPrice.value = v.start;
            c.maxPrice.value = v.end;
          },
        ),
      ],
    ),
  );
}

Widget _priceContainer(BuildContext context, String label, double value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white12),
    ),
    child: Text(
      "$label: \$${value.round()}",
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

Widget _buildBrandImages(BuildContext context, ItemsController c) {
  return Obx(() {
    // 🔴 الآن Obx يراقب selectedCategory.value مباشرة، ولن يظهر الخطأ
    final categoryId = c.selectedCategory.value;
    final brands = c.brands.where((b) => b.id == categoryId).toList();

    if (brands.isEmpty) {
      return Center(child: const Text("No brands found"));
    }

    return Wrap(
      children: brands.map((brand) {
        // نستخدم c.selectedBrands.contains لمراقبة قائمة التحديد
        final isSelected = c.selectedBrands.contains(brand.id);
        return GestureDetector(
          onTap: () => c.toggleBrand(brand.id!),
          child: Text(
            brand.name!,
            style: TextStyle(color: isSelected ? Colors.blue : Colors.white),
          ),
        );
      }).toList(),
    );
  });
}

Widget _buildBottomButtons(BuildContext context, ItemsController c) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
    ),
    child: SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 0,
          ),
          onPressed: () {
            // c.applyFilters(); // يفضل وضع دالة التطبيق هنا
            Get.back();
          },
          child: Obx(() {
            return Text(
              c.activeFiltersCount > 0
                  ? "Apply Filters (${c.activeFiltersCount})"
                  : "Apply Filters",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          }),
        ),
      ),
    ),
  );
}

Widget _buildHandle(ThemeData theme) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    height: 5,
    width: 45,
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
