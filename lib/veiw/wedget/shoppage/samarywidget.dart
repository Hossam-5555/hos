import 'package:flutter/material.dart';
import 'package:hos/controler/checkout&cart/CartController.dart';

class BuildOrderSummary extends StatelessWidget {
  final CartController controller;
  const BuildOrderSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(height: height*0.30,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الإجمالي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإجمالي',
                  style: TextStyle(fontSize: width * 0.04, color: Colors.grey)),
              Text('${controller.totalprice} جنيه',
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: height * 0.01),

          // الخصم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الخصم',
                  style: TextStyle(fontSize: width * 0.04, color: Colors.grey)),
              Text('${controller.couponediscount} %',
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(height: height * 0.03),

          // المجموع الكلي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المجموع الكلي',
                  style: TextStyle(
                      fontSize: width * 0.048, fontWeight: FontWeight.bold)),
              Text('${controller.gettotalprice()} جنيه',
                  style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
            ],
          ),

          SizedBox(height: height * 0.025),

          // زر إتمام الشراء
          Row(
            children: [
              Container(
                height: height * 0.07,
                width: height * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 146, 146, 146).withAlpha(35),
                ),
                child: const Icon(Icons.shopify_outlined,
                    color: Colors.black, size: 24),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.gotochechout(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    textStyle: TextStyle(
                        fontSize: width * 0.045, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('إتمام الشراء'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
