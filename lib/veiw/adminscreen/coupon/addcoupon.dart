// المسار المقترح: lib/veiw/screen/admin/coupon/addcouponpage.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/profile/addcouponcontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class AddCouponPage extends StatelessWidget {
  const AddCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddCouponController());
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: Appbarbackicon(title: "Add Coupon", herotag: "Add Coupon"),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GetBuilder<AddCouponController>(
          builder: (_) {
            return Center(
              child: ConstrainedBox(
                // على التابلت الفورم ميتمططش
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: c.formKey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(w * 0.04, 12, w * 0.04, 32),
                    children: [
                      // ------------------------------------------------ CODE
                      _card(
                        context,
                        title: "Coupon code".tr,
                        icon: Icons.confirmation_number_outlined,
                        children: [
                          TextFormField(
                            controller: c.code,
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z0-9_-]'),
                              ),
                              TextInputFormatter.withFunction(
                                (old, n) =>
                                    n.copyWith(text: n.text.toUpperCase()),
                              ),
                            ],
                            decoration: _dec(
                              context,
                              label: "Code".tr,
                              hint: "SAVE20",
                              icon: Icons.sell_outlined,
                              suffix: IconButton(
                                tooltip: "Generate".tr,
                                icon: const Icon(Icons.auto_awesome),
                                onPressed: c.generateCode,
                              ),
                            ),
                            validator: (v) {
                              final t = v?.trim() ?? '';
                              if (t.isEmpty) return "Required".tr;
                              if (t.length < 3)
                                return "At least 3 characters".tr;
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // -------------------------------------------- DISCOUNT
                      _card(
                        context,
                        title: "Discount".tr,
                        icon: Icons.percent,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: SegmentedButton<String>(
                              segments: [
                                ButtonSegment(
                                  value: 'percentage',
                                  label: Text("Percentage".tr),
                                  icon: const Icon(Icons.percent),
                                ),
                                ButtonSegment(
                                  value: 'fixed',
                                  label: Text("Fixed amount".tr),
                                  icon: const Icon(Icons.payments_outlined),
                                ),
                              ],
                              selected: {c.type},
                              onSelectionChanged: (s) => c.changeType(s.first),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: c.value,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [_decimalOnly],
                            decoration: _dec(
                              context,
                              label: "Discount value".tr,
                              icon: Icons.local_offer_outlined,
                              suffixText: c.isPercentage ? '%' : 'EGP',
                            ),
                            validator: (v) {
                              final n = double.tryParse(v?.trim() ?? '');
                              if (n == null || n <= 0) {
                                return "Enter a valid value".tr;
                              }
                              if (c.isPercentage && n > 100) {
                                return "Maximum is 100%".tr;
                              }
                              return null;
                            },
                          ),
                          if (c.isPercentage) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: c.maxDiscount,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [_decimalOnly],
                              decoration: _dec(
                                context,
                                label: "Max discount (optional)".tr,
                                icon: Icons.vertical_align_top,
                                suffixText: 'EGP',
                              ),
                              validator: _optionalNumber,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ---------------------------------------------- LIMITS
                      _card(
                        context,
                        title: "Conditions".tr,
                        icon: Icons.rule,
                        children: [
                          TextFormField(
                            controller: c.minOrder,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [_decimalOnly],
                            decoration: _dec(
                              context,
                              label: "Minimum order amount (optional)".tr,
                              icon: Icons.shopping_cart_outlined,
                              suffixText: 'EGP',
                            ),
                            validator: _optionalNumber,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: c.usageLimit,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: _dec(
                              context,
                              label: "Usage limit (optional)".tr,
                              icon: Icons.group_outlined,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => c.pickDate(context),
                            child: InputDecorator(
                              decoration: _dec(
                                context,
                                label: "Expiry date (optional)".tr,
                                icon: Icons.event_outlined,
                                suffix: c.expiresAt == null
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: c.clearDate,
                                      ),
                              ),
                              child: Text(
                                c.expiresAt == null
                                    ? "No expiry".tr
                                    : c.dateText,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // --------------------------------------------- ACTIVE
                      _card(
                        context,
                        title: "Status".tr,
                        icon: Icons.toggle_on_outlined,
                        children: [
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: Text("Active".tr),
                            subtitle: Text(
                              "Customers can use this coupon right away".tr,
                            ),
                            value: c.isActive,
                            onChanged: c.toggleActive,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ------------------------------------------- SUBMIT
                      Center(
                        child: Checkbutton(
                          statusrequest: c.statusrequest,
                          buttonColor: Theme.of(context).primaryColor,
                          width: math.min(w * 0.92, 480.0),
                          onTap: c.submit,
                          buttonName: "Add Coupon".tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// HELPERS
// ============================================================================

final _decimalOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));

String? _optionalNumber(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null;
  final n = double.tryParse(t);
  return (n == null || n < 0) ? "Enter a valid value".tr : null;
}

Widget _card(
  BuildContext context, {
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.withAlpha(40)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 21),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...children,
      ],
    ),
  );
}

InputDecoration _dec(
  BuildContext context, {
  required String label,
  IconData? icon,
  String? hint,
  String? suffixText,
  Widget? suffix,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: icon == null ? null : Icon(icon, size: 20),
    suffixText: suffixText,
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.grey.withAlpha(20),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}
