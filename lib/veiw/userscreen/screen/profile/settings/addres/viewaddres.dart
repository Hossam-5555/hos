import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class ViewMyAddres extends StatelessWidget {
  const ViewMyAddres({super.key});

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "My Address"),
      ),
      body: GetBuilder<AddressController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: controller.listaddresdata.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "${controller.listaddresdata[index].addresName}",
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          controller.deleteAddres(
                            controller.listaddresdata[index].addresId
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
