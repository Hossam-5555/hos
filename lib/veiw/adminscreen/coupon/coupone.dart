import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/profile/addcouponcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/adminscreen/coupon/addcoupon.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class ViewCoupons extends StatelessWidget {
  const ViewCoupons({super.key});

  static const Color primaryColor = Color(0xFF0A192F);
  static const Color accentColor = Color(0xFFE9E4DB);

  final List<Map<String, dynamic>> coupons = const [
    {
      'code': 'WELCOME20',
      'discount': 20,
      'type': 'percentage',
      'min_order': 500,
      'expiry': '2026-12-30',
      'active': true,
    },
    {
      'code': 'SAVE100',
      'discount': 100,
      'type': 'fixed',
      'min_order': 1000,
      'expiry': '2026-11-15',
      'active': true,
    },
    {
      'code': 'FREESHIP',
      'discount': 15,
      'type': 'percentage',
      'min_order': 300,
      'expiry': '2026-09-01',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarbackicon(title: "manage coupon", herotag: "manage"),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: HandlingDataView(
                statusrequest: Statusrequest.none,
                widget: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  itemCount: coupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildCouponCard(coupons[index], context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddCouponPage());
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'إضافة كوبون',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final activeCount = coupons.where((coupon) {
      return coupon['active'] == true &&
          DateTime.tryParse(coupon['expiry']) != null &&
          !DateTime.parse(coupon['expiry']).isBefore(DateTime.now());
    }).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.confirmation_number_outlined,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'كوبونات الخصم',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${coupons.length} كوبون • $activeCount نشط',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon, context) {
    final expiry = DateTime.tryParse(coupon['expiry']);
    final expired = expiry == null || expiry.isBefore(DateTime.now());

    final isActive = coupon['active'] == true && !expired;
    final isPercentage = coupon['type'] == 'percentage';

    final discountText = isPercentage
        ? '${coupon['discount']}%'
        : '${coupon['discount']} ج.م';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EAF0)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.local_offer_outlined,
                    // color: primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon['code'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isPercentage
                            ? 'خصم بنسبة ${coupon['discount']}%'
                            : 'خصم ${coupon['discount']} جنيه',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'نسخ الكود',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: coupon['code']));
                    Get.snackbar(
                      'تم النسخ',
                      'تم نسخ كود ${coupon['code']}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: primaryColor,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, color: primaryColor),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEDEFF3)),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 19),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('الحد الأدنى للطلب')),
                    Text(
                      '${coupon['min_order']} ج.م',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 19),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'تاريخ الانتهاء',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      coupon['expiry'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.green : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isActive ? 'نشط' : 'غير متاح',
                      style: TextStyle(
                        color: isActive
                            ? Colors.green.shade700
                            : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'قيمة الخصم: $discountText',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
