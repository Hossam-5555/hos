import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/home_page.dart';
import 'package:hos/veiw/wedget/shared_product_card.dart';

class HomeBrand {
  final int id;
  final String name;
  const HomeBrand({required this.id, required this.name});
}

// ═══════════════════════════════════════════════════════════════
//  النماذج (مطابقة لرد الباك: home/extras)
// ═══════════════════════════════════════════════════════════════

class HomeBanner {
  final String? imageUrl;
  final String title;
  final String titleAr;
  final String subtitle;
  final String subtitleAr;
  final List<Color> colors; // لون احتياطي لحد ما الصورة تحمّل
  final String targetType; // none | category | item
  final int? targetId;

  const HomeBanner({
    this.imageUrl,
    this.title = '',
    this.titleAr = '',
    this.subtitle = '',
    this.subtitleAr = '',
    this.colors = const [Color(0xFF1C1C22), Color(0xFF4A4A5A)],
    this.targetType = 'none',
    this.targetId,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> j) => HomeBanner(
    imageUrl: j['image']?.toString(),
    title: j['title']?.toString() ?? '',
    titleAr: j['title_ar']?.toString() ?? '',
    subtitle: j['subtitle']?.toString() ?? '',
    subtitleAr: j['subtitle_ar']?.toString() ?? '',
    targetType: j['target_type']?.toString() ?? 'none',
    targetId: (j['target_id'] as num?)?.toInt(),
  );
}

class OfferItem {
  final int id;
  final String name;
  final String nameAr;
  final String? imageUrl;
  final double price; // قبل الخصم
  final double finalPrice; // بعد الخصم
  final int discount; // نسبة مئوية

  const OfferItem({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.price,
    required this.finalPrice,
    required this.discount,
    this.imageUrl,
  });

  /// بيقرأ شكل ItemResource الموجود في الباك
  factory OfferItem.fromJson(Map<String, dynamic> j) => OfferItem(
    id: (j['id'] as num).toInt(),
    name: j['items_name']?.toString() ?? '',
    nameAr: j['items_name_ar']?.toString() ?? '',
    imageUrl: j['items_image']?.toString(),
    price: double.tryParse('${j['items_price']}') ?? 0,
    finalPrice: double.tryParse('${j['price_after_discount']}') ?? 0,
    discount: (double.tryParse('${j['items_discount']}') ?? 0).round(),
  );
}

/// بيانات وهمية مؤقتة — احذفها بعد الربط بالباك.
class HomeMock {
  HomeMock._();
  static const brands = <HomeBrand>[
    HomeBrand(id: 16, name: 'Asus'),
    HomeBrand(id: 13, name: 'Dell'),
    HomeBrand(id: 14, name: 'HP'),
    HomeBrand(id: 15, name: 'Lenovo'),
    HomeBrand(id: 17, name: 'Apple'),
    HomeBrand(id: 18, name: 'Samsung'),
  ];
  static const banners = <HomeBanner>[
    HomeBanner(
      title: 'Up to 30% off laptops',
      titleAr: 'خصم حتى 30% على اللابتوبات',
      subtitle: 'Limited time offer',
      subtitleAr: 'لفترة محدودة',
      colors: [Color(0xFF1C1C22), Color(0xFF4A4A5A)],
    ),
    HomeBanner(
      title: 'New arrivals are here',
      titleAr: 'وصل حديثاً',
      subtitle: 'Discover the latest products',
      subtitleAr: 'اكتشف أحدث المنتجات',
      colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
    ),
  ];

  static const offers = <OfferItem>[
    OfferItem(
      id: 1,
      name: 'Gaming Laptop 15"',
      nameAr: 'لابتوب جيمنج 15 بوصة',
      price: 32000,
      finalPrice: 28800,
      discount: 10,
    ),
    OfferItem(
      id: 3,
      name: 'Mechanical Keyboard',
      nameAr: 'كيبورد ميكانيكي',
      price: 1800,
      finalPrice: 1440,
      discount: 20,
    ),
    OfferItem(
      id: 5,
      name: 'USB-C Hub 7-in-1',
      nameAr: 'موزع USB-C سبعة منافذ',
      price: 850,
      finalPrice: 807.5,
      discount: 5,
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
//  1) البانر السلايدر
// ═══════════════════════════════════════════════════════════════

class HomeBannerSlider extends StatefulWidget {
  final List<HomeBanner> banners;
  final bool isArabic;
  final ValueChanged<HomeBanner>? onTap;
  final Duration interval;

  const HomeBannerSlider({
    super.key,
    required this.banners,
    this.isArabic = false,
    this.onTap,
    this.interval = const Duration(seconds: 4),
  });

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.banners.length < 2) return;
    _timer = Timer.periodic(widget.interval, (_) {
      if (!_controller.hasClients) return;
      final next = (_index + 1) % widget.banners.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didUpdateWidget(covariant HomeBannerSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners.length != widget.banners.length) {
      _index = 0;
      if (_controller.hasClients) _controller.jumpToPage(0);
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        // الارتفاع نسبة من العرض مع حدود دنيا وقصوى (موبايل / تابلت)
        final height = (constraints.maxWidth * 0.42).clamp(150.0, 260.0);

        return Column(
          children: [
            SizedBox(
              height: height,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.banners.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final banner = widget.banners[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _BannerCard(
                      banner: banner,
                      isArabic: widget.isArabic,
                      onTap: widget.onTap == null
                          ? null
                          : () => widget.onTap!(banner),
                    ),
                  );
                },
              ),
            ),
            if (widget.banners.length > 1) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.banners.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: active ? 18 : 6,
                    decoration: BoxDecoration(
                      color: active
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withAlpha(110),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  final HomeBanner banner;
  final bool isArabic;
  final VoidCallback? onTap;

  const _BannerCard({required this.banner, required this.isArabic, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? banner.titleAr : banner.title;
    final subtitle = isArabic ? banner.subtitleAr : banner.subtitle;
    final hasText = title.isNotEmpty || subtitle.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: banner.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            if (banner.imageUrl != null && banner.imageUrl!.isNotEmpty)
              Image.network(
                banner.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            // لو البانر صورة فقط من غير نص، منعتّمش الصورة
            if (hasText) ...[
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x99000000), Color(0x00000000)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title.isNotEmpty)
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  2) Special Offers — منتجات عليها خصم فعلي
// ═══════════════════════════════════════════════════════════════

class SpecialOffersRow extends StatelessWidget {
  final List<OfferItem> items;
  final bool isArabic;
  final void Function(OfferItem item, int index)? onTap;

  /// اختياري: زر في ركن الكارت (مثلاً AddToCartButton)
  final Widget Function(OfferItem item)? actionBuilder;

  const SpecialOffersRow({
    super.key,
    required this.items,
    this.isArabic = false,
    this.onTap,
    this.actionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // كل الأحجام نسبية لعرض الشاشة (موبايل / تابلت)
        final imageSize = (w * 0.26).clamp(88.0, 120.0);
        final cardWidth = (w * 0.82).clamp(240.0, 380.0);

        return SizedBox(
          height: imageSize + 20,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final item = items[i];
              return SizedBox(
                width: cardWidth,
                child: _OfferCard(
                  item: item,
                  isArabic: isArabic,
                  imageSize: imageSize,
                  onTap: onTap == null ? null : () => onTap!(item, i),
                  action: actionBuilder?.call(item),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _OfferCard extends StatelessWidget {
  final OfferItem item;
  final bool isArabic;
  final double imageSize;
  final VoidCallback? onTap;
  final Widget? action;

  const _OfferCard({
    required this.item,
    required this.isArabic,
    required this.imageSize,
    this.onTap,
    this.action,
  });

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final name = isArabic ? item.nameAr : item.name;
    final currency = 'EGP';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1C1C22), Color(0xFF3A3A4A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _OfferImage(url: item.imageUrl),
                    PositionedDirectional(
                      top: 6,
                      start: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${item.discount}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${_fmt(item.finalPrice)} $currency',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: '  ${_fmt(item.price)}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (action != null) ...[const SizedBox(width: 8), action!],
          ],
        ),
      ),
    );
  }
}

class _OfferImage extends StatelessWidget {
  final String? url;
  const _OfferImage({this.url});

  Widget _placeholder() => Container(
    color: Colors.white12,
    child: const Center(
      child: Icon(Icons.image_outlined, color: Colors.white38, size: 30),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _placeholder();
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  3) وصل حديثاً
// ═══════════════════════════════════════════════════════════════

class HomeNewArrivals extends StatelessWidget {
  final List<ItemsModel> items;
  final bool isArabic;
  final ValueChanged<ItemsModel>? onTap;

  /// اختياري: زر يظهر في ركن الكارت (مثلاً AddToCartButton)
  final Widget Function(ItemsModel item)? actionBuilder;

  const HomeNewArrivals({
    super.key,
    required this.items,
    this.isArabic = false,
    this.onTap,
    this.actionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        // عرض الكارت نسبي لعرض الشاشة مع حدود (موبايل / تابلت)
        final cardWidth = (constraints.maxWidth * 0.42).clamp(150.0, 210.0);
        final imageHeight = cardWidth * 0.85;
        final listHeight = imageHeight + 96;

        return SizedBox(
          height: listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final item = items[i];
              return SizedBox(
                width: cardWidth,
                child: SharedProductCard(
                  isen: isArabic,
                  height: listHeight,
                  items: item,
                  onTap: onTap == null ? null : () => onTap!(item),
                  actionButton: AddToCartButton(itemId: item.id!),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// class _Badge extends StatelessWidget {
//   final String text;
//   final Color color;
//   const _Badge({required this.text, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.w800,
//         ),
//       ),
//     );
//   }
