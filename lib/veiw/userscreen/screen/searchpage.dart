import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/itemsmodel.dart';

// ignore: must_be_immutable
class Searchpage extends GetView<HomepageController> {
  Searchpage({super.key, required this.searchdata});
  List<Itemsmodel> searchdata;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),

      itemCount: searchdata.length,
      itemBuilder: (context, i) => InkWell(
        onTap: () {
          controller.gotoitemsdatails(searchdata[i]);
        },
        child: Card(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${LinkApi.imageitems}/${searchdata[i].itemsImage}",
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
                      searchdata[i].itemsName!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${searchdata[i].itemsPrice} جنيه',
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
  }
}
