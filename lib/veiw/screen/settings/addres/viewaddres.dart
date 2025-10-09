import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/addres/addrescontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/routs.dart';

class viewmyaddres extends StatelessWidget {
  const viewmyaddres({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    AddressController addressController = Get.put(AddressController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Approute.addnewaddres);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("My address")),
      body: GetBuilder<AddressController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: controller.ListAddresdata.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "${controller.ListAddresdata[index].addresName}",
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          controller.deleteAddres(
                            controller.ListAddresdata[index].addresId
                                .toString(),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
