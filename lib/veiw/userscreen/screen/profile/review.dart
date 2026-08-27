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
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.72,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _MyReviewCard(
                          review: controller.filteredReviews[i],
                          onDelete: () => controller.deleteReview(
                            controller.filteredReviews[i].id,
                          ),
                          onEdit: () {},
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
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            review.productImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: Theme.of(context).cardColor,
              child: const Icon(Icons.image_not_supported_outlined, size: 32),
            ),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: Theme.of(context).cardColor,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.88),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 13,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    review.rating.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 6,
            right: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.white.withOpacity(0.25),
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onSelected: (v) => v == "edit" ? onEdit() : onDelete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: "edit", child: Text("Edit")),
                    PopupMenuItem(value: "delete", child: Text("Delete")),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  review.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat("d MMM yyyy").format(review.date),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  review.comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
                if (review.images.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.photo_outlined,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${review.images.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
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