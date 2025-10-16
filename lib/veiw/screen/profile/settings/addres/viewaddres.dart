import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/profile/addres/addrescontroller.dart';
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
      appBar: AppBar(
        title: Text("My address"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
            height: 48,
            padding: EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                // إضافة ظل خفيف ليعطي عمقاً
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 24, // الخطوة 4: تحديد حجم قياسي للأيقونة
              splashRadius: 24, // لجعل تأثير الضغط لا يخرج عن الدائرة
            ),
          ),
        ),
      ),
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
