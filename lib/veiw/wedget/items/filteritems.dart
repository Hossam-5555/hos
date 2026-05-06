import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/filtercontroller.dart';



class AdvancedFilterSheet extends StatelessWidget {
  const AdvancedFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Get.put لضمان وجود الكنترولر في الذاكرة
    final c = Get.put(FilterController());
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            _buildHandle(theme),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildHeader(context, c),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, "Categories"),
                  _buildCategories(c),

                  const SizedBox(height: 28),
                  _buildSectionTitle(context, "Sort By"),
                  _buildSortOptions(c),

                  const SizedBox(height: 28),
                  _buildSectionTitle(context, "Price Range"),
                  _buildPriceSlider(context, c),

                  const SizedBox(height: 28),
                  _buildSectionTitle(context, "Brands"),
                  _buildBrandImages(context, c),

                  const SizedBox(height: 120),
                ],
              ),
            ),
            _buildBottomButtons(context, c),
          ],
        ),
      ),
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

  Widget _buildHeader(BuildContext context, FilterController c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Advanced Filter",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Obx(
          () => c.activeFiltersCount > 0
              ? TextButton(
                  onPressed: c.reset,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  child: const Text("Reset All"),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildCategories(FilterController c) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: c.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = c.categories[index];
          return Obx(() {
            final isSelected = c.selectedCategory.value == cat.id;
            return GestureDetector(
              onTap: () => c.selectCategory(cat.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      cat.icon,
                      size: 18,
                      color: isSelected ? Colors.white : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cat.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

Widget _buildSortOptions(FilterController c) {
  final sortOptions = {
    "newest": {"label": "Newest", "icon": Icons.access_time_rounded},
    "oldest": {"label": "Oldest", "icon": Icons.history_rounded},
    "price_low": {"label": "Lowest Price", "icon": Icons.trending_down_rounded},
    "price_high": {"label": "Highest Price", "icon": Icons.trending_up_rounded},
  };

  // الحل الأضمن: استدعاء القيمة مباشرة في بداية الـ Obx لضمان التسجيل
  return Obx(() {
    // هذه السطر يضمن أن GetX سيراقب التغيير في هذا الجزء من الشاشة
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
        
        // نستخدم currentSort الذي استخرجناه في الأعلى
        bool isSelected = currentSort == key; 
        final theme = Theme.of(context);

        return GestureDetector(
          onTap: () => c.selectedSort.value = key,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected 
                  ? theme.primaryColor.withOpacity(0.1) 
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? theme.primaryColor : theme.dividerColor.withOpacity(0.5),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  option["icon"] as IconData,
                  size: 18,
                  color: isSelected ? theme.primaryColor : theme.hintColor,
                ),
                const SizedBox(width: 8),
                Text(
                  option["label"] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? theme.primaryColor : theme.textTheme.bodyMedium?.color,
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

  Widget _buildPriceSlider(BuildContext context, FilterController c) {
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
            min: c.defaultMin,
            max: c.defaultMax,
            divisions: 50,
            activeColor: Colors.blue,
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(
        "$label: \$${value.round()}",
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBrandImages(BuildContext context, FilterController c) {
    return Obx(() {
      // استدعاء filteredBrands (التي تستهلك selectedCategory.value)
      final brands = c.filteredBrands;

      // حل مشكلة "GetX improper use": نضمن أن Obx دائماً يراقب شيء ما
      if (brands.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "No brands found for this section",
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ),
        );
      }

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: brands.map((brand) {
          // استهلاك selectedBrands.contains يضمن مراقبة التحديد
          final isSelected = c.selectedBrands.contains(brand.id);
          return GestureDetector(
            onTap: () => c.toggleBrand(brand.id),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 75,
                  height: 75,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // color: Colors.white, // يفضل الأبيض لصور اللوجوهات
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: brand.imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  brand.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildBottomButtons(BuildContext context, FilterController c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 0,
            ),
            onPressed: () => Get.back(),
            child: Obx(
              () => Text(
                c.activeFiltersCount > 0
                    ? "Apply Filters (${c.activeFiltersCount})"
                    : "Apply Filters",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
        color: theme.dividerColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
