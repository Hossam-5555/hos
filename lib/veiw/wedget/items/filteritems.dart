import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  var minPrice = 0.0.obs;
  var maxPrice = 1000.0.obs;

  var selectedSort = 0.obs;
  var selectedBrands = <int>[].obs;
  var selectedCategory = 0.obs;
  var rating = 0.0.obs;

  void reset() {
    minPrice.value = 0;
    maxPrice.value = 1000;
    selectedSort.value = 0;
    selectedBrands.clear();
    rating.value = 0;
  }
}
class AdvancedFilterSheet extends StatelessWidget {
  const AdvancedFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FilterController>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (_, scrollController) => Column(
        children: [
          /// handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// ===== Sort Chips =====
                const Text("Sort by"),
                const SizedBox(height: 10),

                Obx(
                  () => Wrap(
                    spacing: 8,
                    children: List.generate(4, (i) {
                      final selected = c.selectedSort.value == i;
                      return ChoiceChip(
                        label: Text("Option ${i + 1}"),
                        selected: selected,
                        onSelected: (_) => c.selectedSort.value = i,
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                /// ===== Price Range =====
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Price: \$${c.minPrice.value.round()} - \$${c.maxPrice.value.round()}"),
                      RangeSlider(
                        min: 0,
                        max: 1000,
                        values: RangeValues(
                          c.minPrice.value,
                          c.maxPrice.value,
                        ),
                        onChanged: (v) {
                          c.minPrice.value = v.start;
                          c.maxPrice.value = v.end;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),

          /// ===== Bottom Buttons =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: c.reset,
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // هنا ابعت الفلتر للـ API
                    },
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}