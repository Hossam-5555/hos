import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Coubone extends GetView<CartController> {
  final void Function(bool)? onChanged;
  const Coubone({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // وضعنا الـ Obx هنا لتراقب أي تغيير في الحالة
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: controller.couponename == null
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.coubonecontroller,
                        decoration: InputDecoration(
                          filled: true,
                          suffixIcon: Checkbutton.widget(
                            h: 40,
                            width: 90,
                            onTap: () {},

                            buttonName: "Apply".tr,
                          ),
                          hintText: "أدخل كود الخصم",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            gapPadding: 6,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Code: ${controller.couponename} Applied! ✅",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
