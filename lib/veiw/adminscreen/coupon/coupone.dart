// المسار المقترح: lib/veiw/screen/admin/coupon/couponspage.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/profile/couponecontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/data/model/coupone_model.dart';
import 'package:hos/veiw/adminscreen/coupon/addcoupon.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  Future<void> _openAdd(CouponsController c) async {
    final added = await Get.to(() => const AddCouponPage());
    if (added == true) c.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CouponsController());
    final r = Rsp.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: Appbarbackicon(title: "Coupons".tr, herotag: "Coupons"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAdd(c),
        icon: const Icon(Icons.add),
        label: Text("Add Coupon".tr),
      ),
      body: GetBuilder<CouponsController>(
        builder: (_) {
          return Center(
            child: ConstrainedBox(
              // على الشاشات الكبيرة المحتوى ميتمططش
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  // ------------------------------------------------ SEARCH
                  Padding(
                    padding: EdgeInsets.fromLTRB(r.s(16), r.s(8), r.s(16), 0),
                    child: Searchbar.reset(
                      ressetfeaild: c.search.text.isNotEmpty,
                      onPressedIcon: c.search.text.isEmpty
                          ? null
                          : c.clearSearch,
                      title: "Search by code".tr,
                      mycontroller: c.search,
                      onChanged: c.onSearch,
                    ),
                  ),

                  SizedBox(height: r.s(6)),

                  // ------------------------------------------------ FILTERS
                  ChipsBar(
                    labels: [
                      "${"All".tr} (${c.countOf('all')})",
                      "${"Active".tr} (${c.countOf('active')})",
                      "${"Inactive".tr} (${c.countOf('inactive')})",
                      "${"Expired".tr} (${c.countOf('expired')})",
                    ],
                    selectedIndex: c.filterIndex,
                    onSelected: c.changeFilter,
                    height: r.s(52),
                    padding: EdgeInsets.symmetric(horizontal: r.s(12)),
                  ),

                  // -------------------------------------------------- BODY
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

  Widget _body(CouponsController c, Rsp r) {
    final status = c.viewStatus;

    return HandlingDataView(
      statusrequest: status,
      emptyStyle: EmptyStateStyle.style2,
      onRetry: () => c.load(),

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
              padding: EdgeInsets.fromLTRB(pad, r.s(8), pad, r.s(100)),
              child: Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final coupon in items)
                    SizedBox(
                      width: cardWidth,
                      child: _CouponCard(coupon: coupon, controller: c),
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
// COUPON CARD
// ============================================================================

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.coupon, required this.controller});

  final CouponModel coupon;
  final CouponsController controller;

  Color get _color {
    switch (coupon.status) {
      case CouponStatus.active:
        return Colors.green;
      case CouponStatus.inactive:
        return Colors.grey;
      case CouponStatus.expired:
        return Colors.red;
      case CouponStatus.usedUp:
        return Colors.orange;
    }
  }

  String get _statusLabel {
    switch (coupon.status) {
      case CouponStatus.active:
        return "Active".tr;
      case CouponStatus.inactive:
        return "Inactive".tr;
      case CouponStatus.expired:
        return "Expired".tr;
      case CouponStatus.usedUp:
        return "Used up".tr;
    }
  }

  String _num(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);

  String get _discountText => coupon.isPercentage
      ? "${_num(coupon.value)}% ${"off".tr}"
      : "${_num(coupon.value)} EGP ${"off".tr}";

  String _date(DateTime d) => d.toIso8601String().split('T').first;

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete coupon".tr),
        content: Text("${coupon.code}  ${"will be permanently deleted".tr}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel".tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Delete".tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) controller.delete(coupon);
  }

  @override
  Widget build(BuildContext context) {
    final r = Rsp.of(context);
    final color = _color;
    final busy = controller.busyIds.contains(coupon.id);

    return Container(
      padding: EdgeInsets.all(r.s(14)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(r.s(20)),
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------ HEADER
          Row(
            children: [
              Container(
                width: r.s(44),
                height: r.s(44),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  color: color,
                  size: r.s(22),
                ),
              ),

              SizedBox(width: r.s(12)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الضغط على الكود ينسخه
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: coupon.code));
                        Get.snackbar(
                          "Copied".tr,
                          coupon.code,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 1),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              coupon.code,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: r.s(16),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          SizedBox(width: r.s(6)),
                          Icon(
                            Icons.copy_rounded,
                            size: r.s(14),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: r.s(3)),

                    Text(
                      _discountText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: r.s(13),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: r.s(8)),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.s(10),
                  vertical: r.s(5),
                ),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(r.s(20)),
                ),
                child: Text(
                  _statusLabel,
                  maxLines: 1,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: r.s(11),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: r.s(12)),

          // ------------------------------------------------------- INFO
          Wrap(
            spacing: r.s(8),
            runSpacing: r.s(8),
            children: [
              if (coupon.minOrderAmount != null)
                _pill(
                  r,
                  Icons.shopping_cart_outlined,
                  "${"Min".tr} ${_num(coupon.minOrderAmount!)} EGP",
                ),
              if (coupon.isPercentage && coupon.maxDiscount != null)
                _pill(
                  r,
                  Icons.vertical_align_top,
                  "${"Max".tr} ${_num(coupon.maxDiscount!)} EGP",
                ),
              _pill(
                r,
                Icons.group_outlined,
                coupon.usageLimit == null
                    ? "${coupon.usedCount} ${"used".tr}"
                    : "${coupon.usedCount} / ${coupon.usageLimit}",
              ),
              _pill(
                r,
                Icons.event_outlined,
                coupon.expiresAt == null
                    ? "No expiry".tr
                    : _date(coupon.expiresAt!),
              ),
            ],
          ),

          Divider(height: r.s(24)),

          // ----------------------------------------------------- ACTIONS
          Row(
            children: [
              Expanded(
                child: Text(
                  coupon.isActive ? "Enabled".tr : "Disabled".tr,
                  style: TextStyle(
                    fontSize: r.s(13),
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Switch.adaptive(
                value: coupon.isActive,
                onChanged: busy ? null : (v) => controller.toggle(coupon, v),
              ),
              IconButton(
                tooltip: "Delete".tr,
                onPressed: busy ? null : () => _confirmDelete(context),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: r.s(22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(Rsp r, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(r.s(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.s(14), color: Colors.grey.shade600),
          SizedBox(width: r.s(5)),
          Text(text, style: TextStyle(fontSize: r.s(12))),
        ],
      ),
    );
  }
}
