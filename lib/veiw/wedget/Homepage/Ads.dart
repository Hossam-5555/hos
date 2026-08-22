import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/veiw/userscreen/screen/offer.dart';

// ─────────────────────────────────────────
// موديل الإعلان
// ─────────────────────────────────────────
class AdModel {
  final String tag; // تاج صغير فوق العنوان (مثل "NEW" أو "HOT")
  final String title;
  final String subtitle;
  final String actionLabel;
  final List<Color> gradient;
  final IconData icon;
  final VoidCallback? onTap;

  const AdModel({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.gradient,
    required this.icon,
    this.onTap,
  });
}

// ─────────────────────────────────────────
// الـ 3 إعلانات الثابتة
// ─────────────────────────────────────────
final List<AdModel> appAds = [
  AdModel(
    tag: 'LIMITED',
    title: 'Free Shipping',
    subtitle: 'On all orders above 500 EGP',
    actionLabel: 'Shop Now',
    gradient: const [Color(0xFF0F2027), Color(0xFF2C5364)],
    icon: Icons.local_shipping_rounded,
  ),
  AdModel(
    tag: 'MEMBERS',
    title: 'Exclusive Deals',
    subtitle: 'Sign up and get 10% off your first order',
    actionLabel: 'Join Free',
    gradient: const [Color(0xFF1a1a2e), Color(0xFF16213e)],
    icon: Icons.stars_rounded,
    onTap: () {
      Get.to(() => Offer());
      // هنا ممكن تضيف أي وظيفة عند الضغط على الإعلان
    },
  ),
  AdModel(
    tag: 'TODAY',
    title: 'Flash Sale',
    subtitle: 'Up to 40% off selected items — ends midnight',
    actionLabel: 'See Offers',
    gradient: const [Color(0xFF200122), Color(0xFF6f0000)],
    icon: Icons.bolt_rounded,
    onTap: () {
      Get.to(() => Offer());
      // هنا ممكن تضيف أي وظيفة عند الضغط على الإعلان
    },
  ),
];

// ─────────────────────────────────────────
// الـ Widget الرئيسي — 3 كارد رأسية
// ─────────────────────────────────────────
class AdsSection extends StatelessWidget {
  const AdsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(appAds.length, (index) {
        final ad = appAds[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index < appAds.length - 1 ? 12 : 0),
          child: _AdCard(ad: ad),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
// كارد الإعلان الواحد
// ─────────────────────────────────────────
class _AdCard extends StatelessWidget {
  final AdModel ad;
  const _AdCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ad.onTap,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: ad.gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ad.gradient.last.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // ── أيقونة ──
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(ad.icon, color: Colors.white, size: 24),
              ),

              const SizedBox(width: 16),

              // ── نصوص ──
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // تاج صغير
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ad.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ad.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ad.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // ── زرار ──
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ad.actionLabel,
                  style: TextStyle(
                    color: ad.gradient.first,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
