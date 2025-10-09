import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/checkout&cart/checkoutcontroller.dart';
// ignore: must_be_immutable
class Listaddrescard extends StatelessWidget {
  Listaddrescard({
    super.key,
    this.onTap,
    required this.isActive,
    required this.titil,
    required this.subtitle,
  });
  void Function()? onTap;
  bool isActive;
  String titil;
  String subtitle;

  // // اختيار افتراضي
  // String selectedAddress = addresses[0]["title"]!;
  // String selectedPayment = paymentMethods[0];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(60), offset: Offset(1, 1)),
          ],
          color: isActive == true
              ? Colors.lightGreenAccent
              : const Color.fromARGB(32, 1, 17, 31),

          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(0),
        height: 70,
        width: 100,
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(
            titil,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Listpaymentcard extends GetView<Checkoutcontroller> {
  Listpaymentcard({
    super.key,
    this.onTap,
    required this.isActive,
    required this.image,
  });
  void Function()? onTap;
  bool isActive;
  String? image;
  // // اختيار افتراضي
  // String selectedAddress = addresses[0]["title"]!;
  // String selectedPayment = paymentMethods[0];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(duration: Duration(milliseconds: 200),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(60), offset: Offset(1, 1)),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(15),
        height:80 ,
        width: 100,
        child: Image.asset(image!, fit: BoxFit.fill,scale: 50,),
      ),
    );
  }
}
