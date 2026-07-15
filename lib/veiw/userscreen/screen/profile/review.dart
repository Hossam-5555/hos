import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/review_controller.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/data/model/reviewmodel.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:intl/intl.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
     Get.put(MyReviewsController());
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: Appbarbackicon(title: "My Reviews", herotag: 'My Reviews'),
      floatingActionButton: GetBuilder<MyReviewsController>(
        builder: (controller) => controller.pendingProducts.isEmpty
            ? const SizedBox.shrink()
            : _PendingReviewsButton(
                count: controller.pendingProducts.length,
                onTap: () => _showPendingSheet(context, controller),
              ),
      ),
      body: GetBuilder<MyReviewsController>(
        builder: (controller) => controller.allReviews.isEmpty
            ? const _EmptyState()
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _StatsHeader(controller: controller, width: width),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StarFilterDelegate(controller: controller),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.04,
                      12,
                      width * 0.04,
                      100,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _MyReviewCard(
                            review: controller.filteredReviews[i],
                            onDelete: () => controller.deleteReview(
                              controller.filteredReviews[i].id,
                            ),
                            onEdit: () {},
                          ),
                        ),
                        childCount: controller.filteredReviews.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showPendingSheet(BuildContext context, MyReviewsController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rate your purchases",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...controller.pendingProducts.map(
              (p) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    p["image"]!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  p["name"]!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text("Rate"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({required this.controller, required this.width});

  final MyReviewsController controller;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.04, 16, width * 0.04, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Appcolor.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _StatItem(value: "${controller.allReviews.length}", label: "Reviews"),
          Container(width: 1, height: 36, color: Colors.grey[300]),
          _StatItem(
            value: controller.averageGivenRating.toStringAsFixed(1),
            label: "Avg. rating",
          ),
          Container(width: 1, height: 36, color: Colors.grey[300]),
          _StatItem(
            value: "${controller.pendingProducts.length}",
            label: "Pending",
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _StarFilterDelegate extends SliverPersistentHeaderDelegate {
  _StarFilterDelegate({required this.controller});

  final MyReviewsController controller;
  final List<int> stars = const [0, 5, 4, 3, 2, 1];

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: stars.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final star = stars[i];
            final selected = controller.starFilter == star;
            return GestureDetector(
              onTap: () => controller.setStarFilter(star),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Appcolor.primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  star == 0 ? "All" : "$star ★",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  double get maxExtent => 54;
  @override
  double get minExtent => 54;
  @override
  bool shouldRebuild(covariant _StarFilterDelegate oldDelegate) => true;
}

class _MyReviewCard extends StatelessWidget {
  const _MyReviewCard({
    required this.review,
    required this.onEdit,
    required this.onDelete,
  });

  final MyReviewModel review;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  review.productImage,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      DateFormat("d MMM yyyy").format(review.date),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.grey[500],
                  size: 20,
                ),
                onSelected: (v) => v == "edit" ? onEdit() : onDelete(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: "edit", child: Text("Edit")),
                  PopupMenuItem(value: "delete", child: Text("Delete")),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 15,
                color: Appcolor.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    review.images[i],
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingReviewsButton extends StatelessWidget {
  const _PendingReviewsButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: Appcolor.primaryColor,
      icon: const Icon(
        Icons.rate_review_outlined,
        color: Colors.white,
        size: 18,
      ),
      label: Text(
        "Rate $count items",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.rate_review_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            "No reviews yet",
            style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
