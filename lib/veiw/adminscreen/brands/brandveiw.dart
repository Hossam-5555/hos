// المسار المقترح: lib/veiw/screen/admin/brand/adminbrandspage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/profile/brandccontroller/brandcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/data/model/brandmodel.dart';
import 'package:hos/veiw/adminscreen/brands/brandformpage.dart';
import 'package:hos/veiw/wedget/Admin/brandcard.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

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
                    child: Searchbar.reset(
                      ressetfeaild: c.search.text.isNotEmpty,
                      onPressedIcon: c.search.text.isEmpty ? null : c.clearSearch,
                      title: "Search brands".tr,
                      mycontroller: c.search,
                      onChanged: c.onSearch,
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

    return HandlingDataView(
      imagePath: Imageasset.animation3,
      emptyStyle: EmptyStateStyle.style2,
      statusrequest: status,
      onRetry: () => c.load(),
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

            // ثلاثة براندات في كل صف
            const cols = 3;

            final cardWidth =
                (box.maxWidth - pad * 2 - gap * (cols - 1)) / cols;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(pad, r.s(8), pad, r.s(100)),
              child: Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final brand in items)
                    SizedBox(
                      width: cardWidth,
                      child: Brandcard(
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
