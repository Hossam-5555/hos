import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/home_page.dart';
import 'package:hos/veiw/wedget/shared_product_card.dart';

// ═══════════════════════════════════════════════════════════════
//  نماذج بيانات بسيطة ومؤقتة.
//  لما نربط الباك: ابني نفس الكلاسات من الـ API وبدّل HomeMock.* في الصفحة.
// ═══════════════════════════════════════════════════════════════

class HomeBanner {
  final String? imageUrl;
  final String title;
  final String titleAr;
  final String subtitle;
  final String subtitleAr;
  final List<Color> colors;

  const HomeBanner({
    this.imageUrl,
    required this.title,
    required this.titleAr,
    this.subtitle = '',
    this.subtitleAr = '',
    this.colors = const [Color(0xFF1C1C22), Color(0xFF4A4A5A)],
  });
}

class HomeBrand {
  final int id;
  final String name;
  const HomeBrand({required this.id, required this.name});
}

class HomeNewItem {
  final int id;
  final String name;
  final String nameAr;
  final double price;
  final int discount; // نسبة مئوية، 0 = بدون خصم
  final String? imageUrl;

  const HomeNewItem({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.price,
    this.discount = 0,
    this.imageUrl,
  });

  double get finalPrice =>
      discount > 0 ? price - (price * discount / 100) : price;
}

/// بيانات وهمية مؤقتة — احذف الكلاس ده بعد الربط بالباك.
class HomeMock {
  HomeMock._();

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
    HomeBanner(
      title: 'Special coupons for you',
      titleAr: 'كوبونات خاصة لك',
      subtitle: 'Apply at checkout',
      subtitleAr: 'استخدمها عند إتمام الطلب',
      colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
    ),
  ];

  static const brands = <HomeBrand>[
    HomeBrand(id: 16, name: 'Asus'),
    HomeBrand(id: 13, name: 'Dell'),
    HomeBrand(id: 14, name: 'HP'),
    HomeBrand(id: 15, name: 'Lenovo'),
    HomeBrand(id: 17, name: 'Apple'),
    HomeBrand(id: 18, name: 'Samsung'),
  ];

  static const newItems = <HomeNewItem>[
    HomeNewItem(
      id: 1,
      name: 'Gaming Laptop 15"',
      nameAr: 'لابتوب جيمنج 15 بوصة',
      price: 32000,
      discount: 10,
    ),
    HomeNewItem(
      id: 2,
      name: 'Wireless Mouse',
      nameAr: 'ماوس لاسلكي',
      price: 450,
    ),
    HomeNewItem(
      id: 3,
      name: 'Mechanical Keyboard',
      nameAr: 'كيبورد ميكانيكي',
      price: 1800,
      discount: 20,
    ),
    HomeNewItem(
      id: 4,
      name: 'Noise Cancelling Headset',
      nameAr: 'سماعة عازلة للضوضاء',
      price: 2500,
    ),
    HomeNewItem(
      id: 5,
      name: 'USB-C Hub 7-in-1',
      nameAr: 'موزع USB-C سبعة منافذ',
      price: 850,
      discount: 5,
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
//  1) بانر سلايدر
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
            // تعتيم خفيف من تحت عشان النص يبان على أي صورة
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
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  2) صف البراندات
// ═══════════════════════════════════════════════════════════════

class HomeBrandsRow extends StatelessWidget {
  final List<HomeBrand> brands;
  final ValueChanged<HomeBrand>? onTap;

  const HomeBrandsRow({super.key, required this.brands, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final brand = brands[i];
          return Material(
            color: Theme.of(context).cardColor,
            shape: StadiumBorder(
              side: BorderSide(color: Colors.grey.withAlpha(70)),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: onTap == null ? null : () => onTap!(brand),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sell_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      brand.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
