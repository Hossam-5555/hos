import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/data/model/cartmodel.dart';

Widget buildCartItemCard(
  BuildContext context,
  cartmodel cart,
  CartController controller,
  int i,
) {
  return GetBuilder<CartController>(
    builder: (controller) => Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "${LinkApi.imageitems}/${cart.itemsImage}",
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
                    cart.itemsName!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${controller.data[i].totalprice} جنيه',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    controller.decrement(cart.itemsId!);
                  },
                ),
                Text(
                  '${controller.data[i].cartCount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: const Color.fromARGB(255, 134, 180, 81),
                  ),
                  onPressed: () {
                    controller.increment(cart.itemsId!.toString());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
