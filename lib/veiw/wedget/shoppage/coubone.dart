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
              const Text(
                "Have A Code?",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Switch.adaptive(
                activeColor: Colors.lightBlueAccent,
                value: controller.coupone.value,
                onChanged: onChanged, // تأكد انك بتغير controller.coupone.value في الـ onChanged
              ),
            ],
          ),
          
          // إظهار الحقول فقط إذا كان السويتش مفعل
          if (controller.coupone.value) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: controller.couponename == null
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.coubonecontroller,
                            decoration: InputDecoration(
                              hintText: "أدخل كود الخصم",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Apply"),
                        ),
                      ],
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