import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/model/itemsmodel.dart';

class BrandPicker extends StatelessWidget {
  final List<Brandmodel> brands;
  final Brandmodel? selected;
  final bool isLoading;
  final ValueChanged<Brandmodel?> onChanged;

  const BrandPicker({
    super.key,
    required this.brands,
    required this.selected,
    required this.onChanged,
    this.isLoading = false,
  });

  bool get _enabled => !isLoading && brands.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = isLoading
        ? "Loading...".tr
        : brands.isEmpty
        ? "لا توجد براندات لهذا القسم"
        : (selected?.name ?? "Select brand".tr);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _enabled ? () => _openSheet(context) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withAlpha(90)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.sell_outlined, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: selected == null || !_enabled
                      ? Colors.grey
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: selected != null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _openSheet(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: Get.height * 0.6,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select brand".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.block, color: Colors.grey),
                          title: Text("بدون براند".tr),
                          trailing: selected == null
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            onChanged(null);
                            Get.back();
                          },
                        ),
                        ...brands.map(
                          (b) => ListTile(
                            title: Text(b.name!),
                            trailing: selected?.id == b.id
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () {
                              onChanged(b);
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
