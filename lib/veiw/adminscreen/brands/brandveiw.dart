// المسار المقترح: lib/veiw/screen/admin/brand/adminbrandspage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/profile/brandccontroller/brandcontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/data/model/brandmodel.dart';
import 'package:hos/veiw/adminscreen/brands/brandformpage.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';

class AdminBrandsPage extends StatelessWidget {
  const AdminBrandsPage({super.key});

  /// إضافة (brand = null) أو تعديل. لما نرجع بنجاح بنعمل refresh للقائمة.
  Future<void> _openForm(
    AdminBrandsController c, {
    AdminBrandModel? brand,
  }) async {
    final changed = await Get.to(
      () => const AdminBrandFormPage(),
      arguments: {'brand': brand},
    );
    if (changed == true) c.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AdminBrandsController());
    final r = Rsp.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: Appbarbackicon(title: "Brands".tr, herotag: "Brands"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(c),
        icon: const Icon(Icons.add),
        label: Text("Add Brand".tr),
      ),
      body: GetBuilder<AdminBrandsController>(
        builder: (_) {
          return Center(
            child: ConstrainedBox(
              // على الشاشات الكبيرة المحتوى ميتمططش
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  // -------------------------------------------------- SEARCH
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      r.s(16),
                      r.s(8),
                      r.s(16),
                      r.s(8),
                    ),
                    child: TextField(
                      controller: c.search,
                      onChanged: c.onSearch,
                      decoration: InputDecoration(
                        hintText: "Search brands".tr,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: c.search.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: c.clearSearch,
                              ),
                        filled: true,
                        fillColor: Colors.grey.withAlpha(20),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: r.s(14),
                          vertical: r.s(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(r.s(14)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // ---------------------------------------------------- BODY
                  Expanded(child: _body(c, r)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // BODY  (HandlingDataView بيتولى التحميل والخطأ والفراغ)
  // ==========================================================================

  Widget _body(AdminBrandsController c, Rsp r) {
    final status = c.viewStatus;
    final isEmpty = status == Statusrequest.nodata;
    final noBrands = c.brands.isEmpty;

    return HandlingDataView(emptyStyle: EmptyStateStyle.style2,
      statusrequest: status,
      onRetry: () => c.load(),
      // الرسائل المخصصة بتظهر في حالة "فاضي" بس
      message: !isEmpty
          ? null
          : noBrands
          ? "No brands yet".tr
          : "No results".tr,
      subMessage: !isEmpty
          ? null
          : noBrands
          ? "Tap + to add your first brand.".tr
          : "Try a different search.".tr,
      widget: RefreshIndicator(
        onRefresh: c.refreshList,
        child: LayoutBuilder(
          builder: (context, box) {
            final items = c.visible;
            final pad = r.s(16);
            final gap = r.s(12);

            // عدد الأعمدة حسب العرض المتاح
            final cols = box.maxWidth >= 900
                ? 3
                : box.maxWidth >= 600
                ? 2
                : 1;
            final cardWidth =
                (box.maxWidth - pad * 2 - gap * (cols - 1)) / cols;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              // 100 سفلي عشان زرار الإضافة العايم
              padding: EdgeInsets.fromLTRB(pad, r.s(4), pad, r.s(100)),
              child: Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final brand in items)
                    SizedBox(
                      width: cardWidth,
                      child: _BrandCard(
                        brand: brand,
                        controller: c,
                        onEdit: () => _openForm(c, brand: brand),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// BRAND CARD
// ============================================================================

class _BrandCard extends StatelessWidget {
  const _BrandCard({
    required this.brand,
    required this.controller,
    required this.onEdit,
  });

  final AdminBrandModel brand;
  final AdminBrandsController controller;
  final VoidCallback onEdit;

  // String get _initial {كويسه جربها
  //   final t = brand.name.trim();
  //   return t.isEmpty ? '?' : String.fromCharCode(t.runes.first).toUpperCase();
  // }

  Future<void> _onDelete(BuildContext context) async {
    // البراند مربوط بمنتجات: نشرح السبب بدل ما نبعت طلب هيترفض
    if (brand.isInUse) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.info_outline, color: Colors.orange),
          title: Text("Can't delete brand".tr),
          content: Text(
            "brand_in_use".trParams({'count': '${brand.itemsCount}'}),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("OK".tr),
            ),
          ],
        ),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete brand".tr),
        content: Text("${brand.name}  ${"will be permanently deleted".tr}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel".tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              "Delete".tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (ok == true) controller.delete(brand);
  }

  @override
  Widget build(BuildContext context) {
    final r = Rsp.of(context);
    final busy = controller.busyIds.contains(brand.id);

    return Material(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.s(20)),
        side: BorderSide(color: Colors.grey.withAlpha(40)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(r.s(20)),
        onTap: busy ? null : onEdit,
        child: Padding(
          padding: EdgeInsets.all(r.s(14)),
          child: Row(
            children: [
              // ---------------------------------------------------- AVATAR
              // CircleAvatar(
              //   radius: r.s(24),
              //   backgroundColor: primary.withAlpha(25),
              //   child: Text(
              //     _initial,
              //     style: TextStyle(
              //       color: primary,
              //       fontWeight: FontWeight.bold,
              //       fontSize: r.s(18),
              //     ),
              //   ),
              // ),

              SizedBox(width: r.s(12)),

              // ------------------------------------------------------ INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: r.s(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.s(2)),
                    Text(
                      "#${brand.id}",
                      style: TextStyle(
                        fontSize: r.s(11),
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: r.s(8)),
                    Wrap(
                      spacing: r.s(8),
                      runSpacing: r.s(6),
                      children: [
                        _pill(
                          r,
                          Icons.inventory_2_outlined,
                          "${brand.itemsCount} ${"Products".tr}",
                        ),
                        _pill(
                          r,
                          Icons.category_outlined,
                          "${brand.categoriesCount} ${"Categories".tr}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: r.s(4)),

              // --------------------------------------------------- ACTIONS
              if (busy)
                Padding(
                  padding: EdgeInsets.all(r.s(12)),
                  child: SizedBox(
                    width: r.s(22),
                    height: r.s(22),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: "Edit Brand".tr,
                      onPressed: onEdit,
                      icon: Icon(Icons.edit_outlined, size: r.s(22)),
                    ),
                    IconButton(
                      tooltip: "Delete".tr,
                      onPressed: () => _onDelete(context),
                      icon: Icon(
                        Icons.delete_outline,
                        size: r.s(22),
                        color: brand.isInUse ? Colors.grey : Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(Rsp r, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.s(9), vertical: r.s(5)),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(r.s(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.s(13), color: Colors.grey.shade600),
          SizedBox(width: r.s(4)),
          Text(text, style: TextStyle(fontSize: r.s(11))),
        ],
      ),
    );
  }
}