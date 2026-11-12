import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/additemcontroller.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/Admin/selectbrand.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

/// Add:  Get.to(() => ItemFormScreen(categoryId: catid, categoryName: catname));
/// Edit: Get.to(() => ItemFormScreen(item: model));
class ItemFormScreen extends GetView<ItemFormController> {
  const ItemFormScreen({
    super.key,
    this.item,
    this.categoryId,
    this.categoryName,
  });

  final ItemsModel? item;
  final Object? categoryId;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    Get.put(
      ItemFormController(
        item: item,
        categoryId: categoryId,
        categoryName: categoryName,
      ),
    );

    return GetBuilder<ItemFormController>(
      builder: (c) => Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04, bottom: 5),
          child: SafeArea(
            child: Checkbutton(
              width: w * 0.8,
              statusrequest: c.statusrequest,
              onTap: () {
                c.isLoading ? null : c.submit();
              },
              buttonName: (c.isEdit ? 'update' : 'add').tr,
            ),
          ),
        ),
        appBar: Appbarbackicon(
          title: (c.isEdit ? 'edit_item' : 'add_item').tr,
          herotag: "viewproducts",
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final wide = w >= 800; // two-column layout
              final pairs = wide || w >= 560; // fields side by side
              final hPad = wide ? 32.0 : (w < 360 ? 12.0 : 16.0);

              final images = _Card(child: _ImagesSection(c: c));
              final status = _Card(child: _StatusTile(c: c));
              final basic = _Card(
                child: _BasicSection(c: c, wide: pairs),
              );
              final pricing = _Card(
                child: _PricingSection(c: c, wide: pairs),
              );

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Form(
                    key: c.formKey,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsetsDirectional.fromSTEB(
                        hPad,
                        20,
                        hPad,
                        32,
                      ),
                      child: Column(
                        children: [
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      images,
                                      const SizedBox(height: 16),
                                      status,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    children: [
                                      basic,
                                      const SizedBox(height: 16),
                                      pricing,
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            images,
                            const SizedBox(height: 16),
                            basic,
                            const SizedBox(height: 16),
                            pricing,
                            const SizedBox(height: 16),
                            status,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── shared pieces ─────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final narrow = MediaQuery.sizeOf(context).width < 360;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(narrow ? 14 : 20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

/// Two fields side by side on wide screens, stacked otherwise.
Widget _pair(bool wide, Widget a, Widget b) {
  if (!wide) return Column(children: [a, b]);
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: a),
      const SizedBox(width: 16),
      Expanded(child: b),
    ],
  );
}

Widget _field({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required String? Function(String?) validator,
  int maxLines = 1,
  bool number = false,
  bool decimal = false,
  TextDirection? textDirection,
  TextInputAction action = TextInputAction.next,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      textDirection: textDirection,
      textInputAction: maxLines > 1 ? TextInputAction.newline : action,
      keyboardType: number
          ? TextInputType.numberWithOptions(decimal: decimal)
          : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      inputFormatters: number
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        labelText: label,
        prefixIcon: Icon(icon),
        alignLabelWithHint: maxLines > 1,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}

// ───────────────────────── images ─────────────────────────

class _ImagesSection extends StatelessWidget {
  const _ImagesSection({required this.c});
  final ItemFormController c;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final existing = c.existingImageUrl;
    final showExisting = c.isEdit && c.images.isEmpty && existing != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('item_images'.tr),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: c.pickImages,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 110),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.primary, width: 1.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_rounded,
                  color: cs.primary,
                  size: 34,
                ),
                const SizedBox(height: 6),
                Text(
                  'tap_to_select_images'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'select_multiple_hint'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: cs.outline),
                ),
              ],
            ),
          ),
        ),
        if (showExisting || c.images.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (showExisting)
                _Thumb(
                  isMain: true,
                  child: Image.network(
                    existing,
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image_outlined),
                  ),
                ),
              for (int i = 0; i < c.images.length; i++)
                _Thumb(
                  isMain: i == 0,
                  onRemove: () => c.removeImage(i),
                  child: Image.file(
                    c.images[i],
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.child, required this.isMain, this.onRemove});
  final Widget child;
  final bool isMain;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: child,
            ),
          ),
          if (onRemove != null)
            PositionedDirectional(
              top: -6,
              end: -6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          if (isMain)
            PositionedDirectional(
              bottom: 4,
              start: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'main_image'.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ───────────────────────── basic info ─────────────────────────

class _BasicSection extends StatelessWidget {
  const _BasicSection({required this.c, required this.wide});
  final ItemFormController c;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('basic_info'.tr),
        if (c.categoryName != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Chip(
              avatar: const Icon(Icons.category_outlined, size: 18),
              label: Text('${'category'.tr}: ${c.categoryName}'),
            ),
          ),
          const SizedBox(height: 12),
          GetBuilder<ItemFormController>(
            builder: (c) => BrandPicker(
              brands: c.brandsList,
              selected: c.selectedBrand,
              isLoading: c.isBrandsLoading,
              onChanged: (b) {
                c.selectedBrand = b;
                c.update();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],

        _pair(
          wide,
          _field(
            controller: c.namear,
            label: 'item_name_ar'.tr,
            icon: Icons.title,
            textDirection: TextDirection.rtl,
            validator: c.requiredValidator,
          ),
          _field(
            controller: c.name,
            label: 'item_name_en'.tr,
            icon: Icons.title_outlined,
            textDirection: TextDirection.ltr,
            validator: c.requiredValidator,
          ),
        ),
        _field(
          controller: c.descriptionar,
          label: 'item_desc_ar'.tr,
          icon: Icons.description,
          maxLines: 3,
          textDirection: TextDirection.rtl,
          validator: c.requiredValidator,
        ),
        _field(
          controller: c.description,
          label: 'item_desc_en'.tr,
          icon: Icons.description_outlined,
          maxLines: 3,
          textDirection: TextDirection.ltr,
          validator: c.requiredValidator,
        ),
      ],
    );
  }
}

// ───────────────────────── pricing & stock ─────────────────────────

class _PricingSection extends StatelessWidget {
  const _PricingSection({required this.c, required this.wide});
  final ItemFormController c;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('pricing_stock'.tr),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _field(
                controller: c.price,
                label: 'price'.tr,
                icon: Icons.attach_money,
                number: true,
                decimal: true,
                validator: c.priceValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _field(
                controller: c.discount,
                label: 'discount_percent'.tr,
                icon: Icons.percent,
                number: true,
                decimal: true,
                action: TextInputAction.done,
                validator: c.discountValidator,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outline),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'stock_quantity'.tr,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: c.decStock,
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${c.stock}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: c.incStock,
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── status ─────────────────────────

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.c});
  final ItemFormController c;

  @override
  Widget build(BuildContext context) {
    final isActive = c.active == 1;
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text('item_status'.tr),
      subtitle: Text(
        (isActive ? 'item_active_hint' : 'item_hidden_hint').tr,
        style: TextStyle(
          color: isActive ? Colors.green : Theme.of(context).disabledColor,
          fontSize: 12,
        ),
      ),
      value: isActive,
      onChanged: c.toggleActive,
    );
  }
}
