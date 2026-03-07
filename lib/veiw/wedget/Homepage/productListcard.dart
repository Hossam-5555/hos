import 'package:flutter/material.dart';

class ProductListCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final double rating;
  final VoidCallback? onTap;

  const ProductListCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ===== Image =====
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 8),

            /// ===== title =====
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black
              ),
            ),

            const SizedBox(height: 6),

            /// rating
            Row(
              children: [
                const Icon(Icons.star, size: 15, color: Colors.amber),
                const SizedBox(width: 4),
                Text(rating.toString()),
              ],
            ),


            /// price + cart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$$price",
                  style: const TextStyle(color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}