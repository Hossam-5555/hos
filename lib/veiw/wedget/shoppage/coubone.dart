import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Coubone extends StatelessWidget {
  final Checkoutcontroller c;
  const Coubone({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final applied = c.appliedCode != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(40)),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 5,
            offset: const Offset(0, 0.2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: c.coubonecontroller,
                  enabled: !applied && !c.isCouponLoading,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => applied ? null : c.applyCoupon(),
                  decoration: InputDecoration(
                    hintText: "Coupon code".tr,
                    prefixIcon: const Icon(Icons.local_offer_outlined),
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Checkbutton.widget(
                h: 48,
                statusrequest: c.statusrequest,
                buttonColor: Colors.black,
                width: 100,
                onTap: () {
                  if (applied) {
                    c.removeCoupon();
                  } else {
                    c.applyCoupon();
                  }
                },
                buttonName: applied ? "Remove".tr : "Apply".tr,
              ),
            ],
          ),
          if (c.couponError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                c.couponError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          if (applied)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "Coupon applied".tr,
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
