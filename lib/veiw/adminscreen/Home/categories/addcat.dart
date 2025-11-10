import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/addcatcontroller.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';

class Addcategories extends StatelessWidget {
  const Addcategories({super.key});

  @override
  Widget build(BuildContext context) {
    Addcatcontroller controller = Get.put(Addcatcontroller());
    return Scaffold(
      appBar: AppBar(title: Text("Add categories")),
      body: GetBuilder<Addcatcontroller>(
        builder: (controller) => Form(
          key: controller.validkey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Textfealdauth(
                  hint: "catregories name",
                  label: 'name',
                  suffixIcon: Icons.abc,
                  textEditingController: controller.name,
                  valid: (String? val) {},
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.all(10),
                child: Textfealdauth(
                  hint: "catregories name(Arabic)",
                  label: 'name',
                  suffixIcon: Icons.add_ic_call_outlined,
                  textEditingController: controller.namear,
                  valid: (String? val) {},
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  controller.chooseimage();
                },
                icon: Icon(Icons.add_a_photo),
                label: Text("add a photo"),
              ),
              if (controller.file != null)
                SvgPicture.file(controller.file!, height: 70, width: 70),
              MaterialButton(
                color: Colors.black,
                minWidth: 200,
                height: 50,
                onPressed: () {
                  controller.addcategories();
                },
                child: Text("add ", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
