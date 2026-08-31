import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

void showFilterSheet(BuildContext context, ItemsController c) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // مهم عشان يملا الشاشة
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75, // بيفتح على 85% من الشاشة
        minChildSize: 0.5, // أقل حجم ممكن لما يسحب لتحت
        maxChildSize: 0.80, // أقصى حجم ممكن لما يسحب لفوق
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                _buildHandle(Theme.of(context)),
                Expanded(
                  child: ListView(
                    controller:
                        scrollController, // مهم للـ DraggableScrollableSheet
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
                    ],
                  ),
                ),
                _buildBottomButtons(context, c),
                const SizedBox(height: 28),
              ],
            ),
          );
        },
      );
    },
  );
}

// ─── باقي الـ Widgets زي ما هي من غير تغيير ───

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
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      Obx(() {
        if (c.activeFiltersCount > 0) {
          return TextButton(
            onPressed: c.resetFilters,
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
          min: c.defaultMin,
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
  return GetBuilder<ItemsController>(
    builder: (controller) {
      final brands = controller.brands;

      if (brands.isEmpty) {
        return const Center(child: Text("No brands found"));
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: brands.map((brand) {
            final isSelected = controller.selectedBrands.contains(brand.id);
            return GestureDetector(
              onTap: () => controller.toggleBrand(brand.id!),
              child: Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 56, 61, 61),
                      Colors.grey,
                    ],
                  ),
                ),
                width: 100,
                height: 40,
                child: Text(
                  brand.name!,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}

Widget _buildBottomButtons(BuildContext context, ItemsController c) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Checkbutton.widget(
      width: context.width * 0.7,
      widget: Obx(() {
        return Text(
          c.activeFiltersCount > 0
              ? "Apply Filters (${c.activeFiltersCount})"
              : "Apply Filters",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );
      }),
      buttonColor: Colors.black,
      statusrequest: Statusrequest.none,
      onTap: () {
        c.applyFilters();
        if (Get.isBottomSheetOpen ?? false) {
          Get.back(); // Close the bottom sheet
        }
      },
      buttonName: "buttonName",
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
