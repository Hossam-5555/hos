import 'package:flutter/material.dart';

class ProductListCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  // final String oldPrice;
  final double rating;
  final VoidCallback? onTap;

  const ProductListCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    // required this.oldPrice,
    required this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ===== Image =====
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                image,
                width: 95,
                height: 95,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            /// ===== Info =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// rating
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(rating.toString()),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// price
                  Row(
                    children: [
                      Text(
                        "\$$price",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Text(
                      //   "\$$oldPrice",
                      //   style: const TextStyle(
                      //     decoration: TextDecoration.lineThrough,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            /// ===== cart button =====
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}