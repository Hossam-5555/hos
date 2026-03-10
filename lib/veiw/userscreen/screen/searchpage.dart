import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

// ignore: must_be_immutable
class Searchpage extends StatelessWidget {
  Searchpage({super.key});
  final controller = Get.put(SearchMix());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Searchbar(
          focusNode: controller.focusNode,
          textInputAction: controller.textInputAction,
          onPressedIcon: controller.onsearch,
          onChanged: controller.checksearch,
          title: "17".tr,
          mycontroller: controller.search!,
        ),
        leading: Hero(tag: "Search", child: BackButtonCircle()),
      ),
      body: GetBuilder<SearchMix>(
        builder: (controller) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),

            itemCount: controller.searchlist.length,
            itemBuilder: (context, i) => InkWell(
              onTap: () {
                controller.gotoitemsdatails(controller.searchlist[i]);
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "${LinkApi.imageitems}/${controller.searchlist[i].itemsImage}",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.searchlist[i].itemsName!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${controller.searchlist[i].itemsPrice} ${"18".tr}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
