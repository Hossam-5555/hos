// المسار المقترح: lib/veiw/screen/admin/brand/adminbrandformpage.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/profile/brandccontroller/brandformcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';

/// صفحة واحدة للإضافة والتعديل.
/// التعديل: Get.to(() => const AdminBrandFormPage(), arguments: {'brand': brand})
class AdminBrandFormPage extends StatelessWidget {
  const AdminBrandFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AdminBrandFormController());
    final r = Rsp.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: Appbarbackicon(
        title: c.isEdit ? "Edit Brand".tr : "Add Brand".tr,
        herotag: "brandformpage",
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GetBuilder<AdminBrandFormController>(
          builder: (_) {
            // الفورم محتاج قائمة الأقسام، فتحميلها والخطأ والفراغ عن طريق HandlingDataView
            return HandlingDataView(
              statusrequest: c.categoriesStatus,
              onRetry: c.loadCategories,
              message: c.categoriesStatus == Statusrequest.nodata
                  ? "No categories yet".tr
                  : null,
              subMessage: c.categoriesStatus == Statusrequest.nodata
                  ? "Add a category first, then link the brand to it.".tr
                  : null,
              widget: Center(
                child: ConstrainedBox(
                  // على التابلت والويب الفورم ميتمططش
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: c.formKey,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        r.s(16),
                        r.s(12),
                        r.s(16),
                        r.s(32),
                      ),
                      children: [
                        // ---------------------------------------------- NAME
                        _card(
                          context,
                          r,
                          title: "Brand name".tr,
                          icon: Icons.sell_outlined,
                          child: TextFormField(
                            controller: c.name,
                            autofocus: !c.isEdit,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => c.submit(),
                            decoration: _dec(
                              context,
                              r,
                              label: "Brand name".tr,
                              icon: Icons.label_outline,
                            ),
                            validator: (v) {
                              final t = v?.trim() ?? '';
                              if (t.isEmpty) return "Required".tr;
                              if (t.length < 2) {
                                return "At least 2 characters".tr;
                              }
                              if (t.length > 100) {
                                return "Maximum 100 characters".tr;
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: r.s(12)),

                        // ----------------------------------------- CATEGORIES
                        _card(
                          context,
                          r,
                          title: "Categories".tr,
                          icon: Icons.category_outlined,
                          trailing: TextButton(
                            onPressed: c.toggleAll,
                            child: Text(
                              c.allSelected ? "Clear".tr : "Select all".tr,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${c.selected.length} / ${c.categories.length}",
                                style: TextStyle(
                                  fontSize: r.s(12),
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: r.s(10)),
                              // Wrap: الـ chips بتنزل لسطر جديد حسب العرض المتاح
                              Wrap(
                                spacing: r.s(8),
                                runSpacing: r.s(4),
                                children: [
                                  for (final cat in c.categories)
                                    FilterChip(
                                      label: Text(cat.label(isAr)),
                                      labelStyle: TextStyle(fontSize: r.s(13)),
                                      selected: c.selected.contains(cat.id),
                                      onSelected: (_) =>
                                          c.toggleCategory(cat.id),
                                    ),
                                ],
                              ),
                              if (c.showCategoryError) ...[
                                SizedBox(height: r.s(10)),
                                Text(
                                  "Select at least one category".tr,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: r.s(12),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: r.s(24)),

                        // -------------------------------------------- SUBMIT
                        Center(
                          child: Checkbutton(
                            statusrequest: c.statusrequest,
                            buttonColor: Theme.of(context).primaryColor,
                            width: math.min(w * 0.92, 480.0),
                            onTap: c.submit,
                            buttonName: c.isEdit
                                ? "Save changes".tr
                                : "Add Brand".tr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// HELPERS
// ============================================================================

Widget _card(
  BuildContext context,
  Rsp r, {
  required String title,
  required IconData icon,
  required Widget child,
  Widget? trailing,
}) {
  return Container(
    padding: EdgeInsets.all(r.s(16)),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(r.s(20)),
      border: Border.all(color: Colors.grey.withAlpha(40)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: r.s(21)),
            SizedBox(width: r.s(9)),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: r.s(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
        SizedBox(height: r.s(15)),
        child,
      ],
    ),
  );
}

InputDecoration _dec(
  BuildContext context,
  Rsp r, {
  required String label,
  IconData? icon,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(r.s(14)),
    borderSide: BorderSide.none,
  );

  return InputDecoration(
    labelText: label,
    prefixIcon: icon == null ? null : Icon(icon, size: r.s(20)),
    filled: true,
    fillColor: Colors.grey.withAlpha(20),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(r.s(14)),
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: r.s(14),
      vertical: r.s(14),
    ),
  );
}
