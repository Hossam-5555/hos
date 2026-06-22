import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';

class Coubone extends GetView<CartController> {
  final void Function(bool)? onChanged;
  const Coubone({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // وضعنا الـ Obx هنا لتراقب أي تغيير في الحالة
    return Obx(() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Have A Code?".tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Switch.adaptive(
                // inactiveTrackColor: Colors.grey.shade300,inactiveThumbColor: Colors.white,
                activeThumbColor: Colors.white,
                thumbIcon: MaterialStateProperty.all(
                  Icon(
                    controller.coupone.value
                        ? Icons.discount
                        : Icons.question_mark,
                    color: controller.coupone.value
                        ? Colors.green
                        : const Color.fromARGB(255, 2, 2, 2),
                  ),
                ),
                trackColor: MaterialStateProperty.all(Colors.grey.shade100),
                value: controller.coupone.value,
                onChanged:
                    onChanged, // تأكد انك بتغير controller.coupone.value في الـ onChanged
              ),
            ],
          ),

          // إظهار الحقول فقط إذا كان السويتش مفعل
          if (controller.coupone.value)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: controller.couponename == null
                  ? AnimatedScale(
                      duration: Duration(seconds: 1),
                      scale: 1,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.coubonecontroller,
                              decoration: InputDecoration(
                                hintText: "أدخل كود الخصم",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Text("Apply"),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
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
    });
  }
}
