import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';

// ───────────────────────── الألوان (غيّرها من هنا بس) ─────────────────────────
class _Palette {
  final Color bg, surface, border, primary, onPrimary, text, textSecondary;

  const _Palette({
    required this.bg,
    required this.surface,
    required this.border,
    required this.primary,
    required this.onPrimary,
    required this.text,
    required this.textSecondary,
  });

  static const _light = _Palette(
    bg: Colors.white,
    surface: Color(0xFFF4F4F4),
    border: Color(0xFFE8E8E8),
    primary: Color(0xFF1A1A1A),
    onPrimary: Colors.white,
    text: Color(0xFF111111),
    textSecondary: Color(0xFF9A9A9A),
  );

  static const _dark = _Palette(
    bg: Color(0xFF121212),
    surface: Color(0xFF1F1F1F),
    border: Color(0xFF2E2E2E),
    primary: Color(0xFFF5F5F5),
    onPrimary: Color(0xFF121212),
    text: Color(0xFFF5F5F5),
    textSecondary: Color(0xFF8E8E93),
  );

  static _Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _dark : _light;
}

// ───────────────────────────── الشيت الرئيسي ─────────────────────────────
void showFilterSheet(BuildContext context, ItemsController c) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final p = _Palette.of(sheetContext);
      return DraggableScrollableSheet(
        initialChildSize: 0.70,
        minChildSize: 0.5,
        maxChildSize: 0.70,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: p.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    children: [
                      _buildSectionTitle("Brands", p),
                      _buildBrands(p),
                      const SizedBox(height: 28),
                      _buildSectionTitle("Price Range", p),
                      _buildPriceRange(c, p),
                      const SizedBox(height: 28),
                      _buildSectionTitle("Sort By", p),
                      _buildSortOptions(c, p),
                    ],
                  ),
                ),
                _buildBottomBar(sheetContext, c, p),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildSectionTitle(String title, _Palette p) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: p.text,
      ),
    ),
  );
}

// ───────────────────────────── Brands ─────────────────────────────
Widget _buildBrands(_Palette p) {
  return GetBuilder<ItemsController>(
    builder: (controller) {
      final brands = controller.brands;

      if (brands.isEmpty) {
        return Center(
          child: Text(
            "No brands found",
            style: TextStyle(color: p.textSecondary),
          ),
        );
      }

      return SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: brands.length,
          separatorBuilder: (_, __) => const SizedBox(width: 18),
          itemBuilder: (_, i) {
            final brand = brands[i];
            final name = brand.name ?? '';
            final selected = controller.selectedBrands.contains(brand.id);

            return GestureDetector(
              onTap: () => controller.toggleBrand(brand.id!),
              child: SizedBox(
                width: 64,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: p.surface,
                            shape: BoxShape.circle,
                          ),
                          // TODO: استبدل الحرف بصورة البراند:
                          // ClipOval(child: Image.network(brand.image!, width: 30, height: 30))
                          child: Text(
                            name.isEmpty ? '?' : name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: p.text,
                            ),
                          ),
                        ),
                        if (selected)
                          PositionedDirectional(
                            end: -2,
                            bottom: -2,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: p.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: p.bg, width: 2),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 12,
                                color: p.onPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: p.text,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

// ───────────────────────────── Price Range ─────────────────────────────
const double _thumbR = 11; // نصف قطر الدائرة

// ارتفاعات الأعمدة الباهتة خلف السلايدر (شكل جمالي فقط)
const _bars = [
  .20,
  .35,
  .30,
  .50,
  .40,
  .65,
  .50,
  .80,
  .60,
  .45,
  .55,
  .90,
  .70,
  .50,
  .60,
  .40,
  .70,
  .55,
  .35,
  .45,
  .30,
  .50,
  .25,
  .35,
  .20,
  .30,
  .15,
  .20,
];

Widget _buildPriceRange(ItemsController c, _Palette p) {
  return Obx(() {
    final min = c.defaultMin;
    final max = c.defaultMax;
    final lo = c.minPrice.value;
    final hi = c.maxPrice.value;

    return LayoutBuilder(
      builder: (context, box) {
        final rtl = Directionality.of(context) == TextDirection.rtl;
        final trackW = box.maxWidth - _thumbR * 2;

        // موضع الثامب (left مادي) مع مراعاة اتجاه اللغة
        double leftOf(double v) {
          final f = (v - min) / (max - min);
          return _thumbR + trackW * (rtl ? 1 - f : f);
        }

        final endStyle = TextStyle(fontSize: 12, color: p.textSecondary);
        final valStyle = TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: p.text,
        );

        return Column(
          children: [
            SizedBox(
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _thumbR),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final h in _bars)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  child: FractionallySizedBox(
                                    heightFactor: h,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: p.border,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(2),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      activeTrackColor: p.primary,
                      inactiveTrackColor: p.border,
                      overlayShape: SliderComponentShape.noOverlay,
                      rangeThumbShape: _RingThumb(fill: p.bg, ring: p.primary),
                    ),
                    child: RangeSlider(
                      values: RangeValues(lo, hi),
                      min: min,
                      max: max,
                      divisions: 50,
                      onChanged: (v) {
                        c.minPrice.value = v.start;
                        c.maxPrice.value = v.end;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 22,
              child: Stack(
                children: [
                  PositionedDirectional(
                    start: 0,
                    child: Text("\$${min.round()}", style: endStyle),
                  ),
                  PositionedDirectional(
                    end: 0,
                    child: Text("\$${max.round()}", style: endStyle),
                  ),
                  Positioned(
                    left: leftOf(lo) - 30,
                    width: 60,
                    child: Text(
                      "\$${lo.round()}",
                      textAlign: TextAlign.center,
                      style: valStyle,
                    ),
                  ),
                  Positioned(
                    left: leftOf(hi) - 30,
                    width: 60,
                    child: Text(
                      "\$${hi.round()}",
                      textAlign: TextAlign.center,
                      style: valStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  });
}

// دائرة بيضاء (أو بلون الخلفية) بإطار سميك
class _RingThumb extends RangeSliderThumbShape {
  const _RingThumb({required this.fill, required this.ring});

  final Color fill;
  final Color ring;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size(_thumbR * 2, _thumbR * 2);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final canvas = context.canvas;
    canvas.drawCircle(center, _thumbR, Paint()..color = fill);
    canvas.drawCircle(
      center,
      _thumbR - 2,
      Paint()
        ..color = ring
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }
}

// ───────────────────────────── Sort By ─────────────────────────────
Widget _buildSortOptions(ItemsController c, _Palette p) {
  const options = {
    "newest": "Newest",
    "oldest": "Oldest",
    "price_low": "Lowest Price",
    "price_high": "Highest Price",
  };

  return Obx(() {
    final current = c.selectedSort.value;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.entries.map((e) {
          final selected = current == e.key;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: GestureDetector(
              onTap: () => c.selectedSort.value = e.key,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: selected ? p.primary : p.bg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: selected ? p.primary : p.border),
                ),
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? p.onPrimary : p.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  });
}

// ───────────────────────────── Reset / Apply ─────────────────────────────
Widget _buildBottomBar(
  BuildContext sheetContext,
  ItemsController c,
  _Palette p,
) {
  return Container(
    decoration: BoxDecoration(
      color: p.bg,
      border: Border(top: BorderSide(color: p.border)),
    ),
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
    child: SafeArea(
      top: false,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Obx(
              () => _pillButton(
                c.activeFiltersCount > 0
                    ? "Reset(${c.activeFiltersCount})"
                    : "Reset",
                filled: false,
                onTap: c.resetFilters,
                p: p,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 6,
            child: _pillButton(
              "Apply",
              filled: true,
              onTap: () {
                c.applyFilters();
                Navigator.pop(sheetContext);
              },
              p: p,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _pillButton(
  String label, {
  required bool filled,
  required VoidCallback onTap,
  required _Palette p,
}) {
  return Material(
    color: filled ? p.primary : p.bg,
    shape: StadiumBorder(
      side: filled ? BorderSide.none : BorderSide(color: p.border),
    ),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: filled ? p.onPrimary : p.text,
            ),
          ),
        ),
      ),
    ),
  );
}
