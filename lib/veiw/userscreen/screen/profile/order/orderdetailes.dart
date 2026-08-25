import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/controler/usercontroller/profile/order/orderdetailescontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/order/detailsorder.dart';

class Orderdetailes extends StatelessWidget {
  const Orderdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Orderdetailescontroller());
    final w = MediaQuery.of(context).size.width;
    // داخل صفحة DetailView
    // ignore: unused_local_variable
    Ordercontroller controller = Get.find();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: c.order?.orderNumber ?? ''),
      ),

      bottomNavigationBar: c.order?.status == "pending"
          ? Padding(
              padding: EdgeInsets.all(w * 0.06),
              child: GetBuilder<Ordercontroller>(
                builder: (controller) {
                  return Checkbutton(
                    statusrequest: controller.statusrequest,
                    buttonColor: Colors.black,
                    width: w,
                    onTap: () {
                      controller.deleteorders(c.order!.orderId);
                    },
                    buttonName: "Cancel Order",
                  );
                },
              ),
            )
          : null,

      body: GetBuilder<Orderdetailescontroller>(
        builder: (_) {
          final o = c.order;
          if (o == null) return Center(child: Text("No Data"));

          c.Getcolorandstause(o.status);

          return ListView(
            padding: EdgeInsets.all(w * 0.04),
            children: [
              statusorder(o.status, c.statusColor!, c.statusText!),
              CardWidget(child:info(o)),
              CardWidget(child:items(o)),
              CardWidget(child:price(o)),
            ],
          );
        },
      ),
    );
  }

  // ---------------- UI ----------------

 
}
