import 'package:flutter/material.dart';
import 'package:hos/data/model/itemsmodel.dart';

// ───────────────────────────── موديلات الفلتر ─────────────────────────────

class FilterBrand {
  final int id;
  final String name;
  const FilterBrand({required this.id, required this.name});
}

class FilterResult {
  final Set<int> brandIds;
  final RangeValues price;
  final String sort;
  final bool inStockOnly;

  const FilterResult({
    required this.brandIds,
    required this.price,
    required this.sort,
    required this.inStockOnly,
  });
}

// ───────────────────────────── الألوان ─────────────────────────────

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

// ───────────────────────────── دالة الفتح ─────────────────────────────

Future<FilterResult?> showFilterSheet(
  BuildContext context, {
  required List<Brandmodel> brands,
  required double minLimit,
  required double maxLimit,
  FilterResult? initial,
}) {
  return showModalBottomSheet<FilterResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheet(
      brands: brands,
      minLimit: minLimit,
      maxLimit: maxLimit,
      initial:
          initial ??
          FilterResult(
            brandIds: const {},
            price: RangeValues(minLimit, maxLimit),
            sort: 'newest',
            inStockOnly: false,
          ),
    ),
  );
}

// ───────────────────────────── الشيت ─────────────────────────────

class _FilterSheet extends StatefulWidget {
  final List<Brandmodel> brands;
  final double minLimit, maxLimit;
  final FilterResult initial;

  const _FilterSheet({
    required this.brands,
    required this.minLimit,
    required this.maxLimit,
    required this.initial,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  static const _sortLabels = {
    'newest': 'Newest',
    'oldest': 'Oldest',
    'price_low': 'Lowest Price',
    'price_high': 'Highest Price',
  };

  late Set<int> _brandIds;
  late RangeValues _price;
  late String _sort;
  late bool _inStock;

  @override
  void initState() {
    super.initState();
    _brandIds = {...widget.initial.brandIds};
    _price = widget.initial.price;
    _sort = widget.initial.sort;
    _inStock = widget.initial.inStockOnly;
  }

  int get _activeCount {
    int count = 0;
    if (_brandIds.isNotEmpty) count++;
    if (_price != RangeValues(widget.minLimit, widget.maxLimit)) count++;
    if (_sort != 'newest') count++;
    if (_inStock) count++;
    return count;
  }

  void _reset() {
    setState(() {
      _brandIds.clear();
      _price = RangeValues(widget.minLimit, widget.maxLimit);
      _sort = 'newest';
      _inStock = false;
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      FilterResult(
        brandIds: {..._brandIds},
        price: _price,
        sort: _sort,
        inStockOnly: _inStock,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: p.bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  children: [
                    _sectionTitle("Brands", p),
                    _brands(p),
                    const SizedBox(height: 28),
                    _sectionTitle("Price Range", p),
                    _priceRange(p),
                    const SizedBox(height: 28),
                    _sectionTitle("Sort By", p),
                    _sortOptions(p),
                    const SizedBox(height: 28),
                    _sectionTitle("Availability", p),
                    _availability(p),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              _bottomBar(p),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, _Palette p) {
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

  // ───── Brands ─────
  Widget _brands(_Palette p) {
    if (widget.brands.isEmpty) {
      return Text("No brands found", style: TextStyle(color: p.textSecondary));
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, i) {
          final brand = widget.brands[i];
          final selected = _brandIds.contains(brand.id);
          final letter = brand.name!;

          return GestureDetector(
            onTap: () => setState(() {
              if (selected) {
                _brandIds.remove(brand.id);
              } else {
                _brandIds.add(brand.id!);
              }
            }),
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
                        child: Text(
                          letter,
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
                    brand.name!,
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
  }

  // ───── Price Range ─────
  Widget _priceRange(_Palette p) {
    final min = widget.minLimit;
    final max = widget.maxLimit;
    final lo = _price.start;
    final hi = _price.end;

    return LayoutBuilder(
      builder: (context, box) {
        final rtl = Directionality.of(context) == TextDirection.rtl;
        final trackW = box.maxWidth - _thumbR * 2;

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
                      values: _price,
                      min: min,
                      max: max,
                      divisions: 50,
                      onChanged: (v) => setState(() => _price = v),
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
  }

  // ───── Sort By ─────
  Widget _sortOptions(_Palette p) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _sortLabels.entries.map((e) {
        return _chip(
          e.value,
          _sort == e.key,
          () => setState(() => _sort = e.key),
          p,
        );
      }).toList(),
    );
  }

  // ───── Availability ─────
  Widget _availability(_Palette p) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _chip("All", !_inStock, () => setState(() => _inStock = false), p),
        _chip("In stock", _inStock, () => setState(() => _inStock = true), p),
      ],
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap, _Palette p) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? p.primary : p.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? p.onPrimary : p.text,
          ),
        ),
      ),
    );
  }

  // ───── Reset / Apply ─────
  Widget _bottomBar(_Palette p) {
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
              child: _pillButton(
                _activeCount > 0 ? "Reset ($_activeCount)" : "Reset",
                filled: false,
                onTap: _reset,
                p: p,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 6,
              child: _pillButton("Apply", filled: true, onTap: _apply, p: p),
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
}

// ───────────────────────────── ثوابت وأدوات السلايدر ─────────────────────────────

const double _thumbR = 11;

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
