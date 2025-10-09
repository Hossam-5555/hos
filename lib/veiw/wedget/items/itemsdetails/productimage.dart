import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/itemsdetailscontroller.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Productimagedetails extends GetView<Itemdetailscontroller> {
  const Productimagedetails({super.key});

  @override
  Widget build(BuildContext context) {
    Itemdetailscontroller itemdetailscontroller=Get.put(Itemdetailscontroller());
    return   ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: '${itemdetailscontroller.itemsmodel.itemsId}',
                child: Image.network(
                  "${LinkApi.imageitems + '/' + controller.itemsmodel.itemsImage!}",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            );
  }
}