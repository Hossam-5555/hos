import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/Homepage/CurvedItemsView.dart';
import 'package:hos/veiw/wedget/Homepage/categorieswidget.dart';
import 'package:hos/veiw/wedget/Homepage/dicountcard.dart';
import 'package:hos/veiw/wedget/Homepage/titles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Get.put(HomepageController());
    final homescreencontroller = Get.put(Homescreencontroller());

    return GetBuilder<HomepageController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            controller: homescreencontroller.scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ عرض البيانات أو نتيجة البحث
                  Handlingdataview(
                    statusrequest: controller.statusrequest,
                    widget: !controller.issearch
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Titles(title: "Categories "),
                              SizedBox(height: height * 0.01),

                              /// 🔥 كاتيجوريز
                              SizedBox(
                                height: height * 0.10, // تعديل نسبي
                                child: listcatigories(),
                              ),

                              /// 🔥 كارت الخصم
                              OfferCard(
                                title: 'خصم على الأجهزة',
                                description:
                                    "خصم يصل إلى 50% على الهواتف واللابتوبات",
                                discount: "50% OFF",
                                onTap: () {},
                              ),

                              SizedBox(
                                height: height * 0.025,
                                child: GetBuilder<HomepageController>(
                                  builder: (controller) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...List.generate(
                                        2,
                                        (index) => AnimatedContainer(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          width: controller.currntofer == index
                                              ? 20
                                              : 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Appcolor.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          duration: Duration(milliseconds: 500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// 🔥 الكيرفيد ايتيمز
                              CurvedItemsView(),

                              Container(
                                margin: EdgeInsets.only(top: 5),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Titles(title: " New Offers"),
                                    SizedBox(width: width * 0.06),
                                    TextButton.icon(
                                      iconAlignment: IconAlignment.start,
                                      onPressed: () {},
                                      icon: Text(
                                        " See All",
                                        style: TextStyle(
                                          color: Appcolor.primaryColor,
                                        ),
                                      ),
                                      label: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Appcolor.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OfferCard(
                                title: 'خصم على الأجهزة',
                                description:
                                    "خصم يصل إلى 50% على الهواتف واللابتوبات",
                                discount: "50% OFF",
                                onTap: () {},
                              ),
                            ],
                          )
                        : Searchpage(searchdata: controller.searchlist),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
