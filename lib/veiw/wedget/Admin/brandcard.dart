import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/profile/brandccontroller/brandcontroller.dart';
import 'package:hos/data/model/brandmodel.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';

class Brandcard extends StatelessWidget {
  final AdminBrandModel brand;
  final AdminBrandsController controller;
  final VoidCallback onEdit;

  const Brandcard({
    super.key,
    required this.brand,
    required this.controller,
    required this.onEdit,
  });

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
            child: Text("Delete".tr, style: const TextStyle(color: Colors.red)),
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
        borderRadius: BorderRadius.circular(r.s(16)),
        side: BorderSide(color: Colors.grey.withAlpha(40)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: busy ? null : onEdit,
        child: Padding(
          padding: EdgeInsets.all(r.s(9)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ------------------------ BRAND IMAGE
              Container(
                width: double.infinity,
                height: r.s(85),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FF),
                  borderRadius: BorderRadius.circular(r.s(12)),
                  border: Border.all(color: const Color(0xFFE9E4DB)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r.s(11)),
                  child: Image.network(
                    'https://placehold.co/300x300/png?text=BRAND',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.storefront_rounded,
                        size: r.s(35),
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: r.s(10)),

              // ------------------------ BRAND NAME
              Text(
                brand.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: r.s(13),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: r.s(3)),

              Text(
                "#${brand.id}",
                style: TextStyle(
                  fontSize: r.s(10),
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: r.s(10)),

              // ------------------------ BRAND INFO
              _pill(
                r,
                Icons.inventory_2_outlined,
                "${brand.itemsCount} ${"Products".tr}",
              ),

              SizedBox(height: r.s(6)),

              _pill(
                r,
                Icons.category_outlined,
                "${brand.categoriesCount} ${"Categories".tr}",
              ),

              SizedBox(height: r.s(8)),

              Divider(height: r.s(1), color: Colors.grey.withAlpha(35)),

              SizedBox(height: r.s(5)),

              // ------------------------ ACTIONS
              if (busy)
                SizedBox(
                  height: r.s(35),
                  child: Center(
                    child: SizedBox(
                      width: r.s(19),
                      height: r.s(19),
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.all(r.s(7)),
                      tooltip: "Edit Brand".tr,
                      onPressed: onEdit,
                      icon: Icon(Icons.edit_outlined, size: r.s(19)),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.all(r.s(7)),
                      tooltip: "Delete".tr,
                      onPressed: () => _onDelete(context),
                      icon: Icon(
                        Icons.delete_outline,
                        size: r.s(19),
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: r.s(5), vertical: r.s(6)),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(r.s(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: r.s(12), color: Colors.grey.shade600),
          SizedBox(width: r.s(4)),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: r.s(10)),
            ),
          ),
        ],
      ),
    );
  }
}
