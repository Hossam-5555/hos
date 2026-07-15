import 'package:get/get.dart';
import 'package:hos/data/model/reviewmodel.dart';

class MyReviewsController extends GetxController {
  final List<MyReviewModel> allReviews = [
    MyReviewModel(
      id: "1",
      productId: "p1",
      productName: "Leather Handbag - Classic Brown",
      productImage: "https://picsum.photos/200?11",
      rating: 5,
      date: DateTime(2026, 6, 20),
      comment: "المنتج فوق الوصف بكتير، الخامة ممتازة والتوصيل كان سريع جداً.",
      images: ["https://picsum.photos/200?1", "https://picsum.photos/200?2"],
    ),
    MyReviewModel(
      id: "2",
      productId: "p2",
      productName: "Wireless Headphones Pro",
      productImage: "https://picsum.photos/200?12",
      rating: 4,
      date: DateTime(2026, 6, 15),
      comment: "جيد جداً بس الألوان مختلفة شوية عن الصور.",
    ),
    MyReviewModel(
      id: "3",
      productId: "p3",
      productName: "Running Shoes Nova",
      productImage: "https://picsum.photos/200?13",
      rating: 3,
      date: DateTime(2026, 5, 30),
      comment: "متوسط، كنت متوقع جودة أعلى بالسعر ده.",
    ),
    MyReviewModel(
      id: "4",
      productId: "p4",
      productName: "Minimal Watch Steel",
      productImage: "https://picsum.photos/200?14",
      rating: 5,
      date: DateTime(2026, 5, 10),
      comment: "من أفضل المنتجات اللي جربتها، هكرر الطلب أكيد.",
      images: ["https://picsum.photos/200?3"],
    ),
  ];

  final List<Map<String, String>> pendingProducts = [
    {"id": "p5", "name": "Silk Scarf Set", "image": "https://picsum.photos/200?15"},
    {"id": "p6", "name": "Sunglasses Aviator", "image": "https://picsum.photos/200?16"},
  ];

  List<MyReviewModel> filteredReviews = [];
  int starFilter = 0;

  @override
  void onInit() {
    filteredReviews = List.from(allReviews);
    super.onInit();
  }

  double get averageGivenRating {
    if (allReviews.isEmpty) return 0;
    final sum = allReviews.fold<int>(0, (a, r) => a + r.rating);
    return sum / allReviews.length;
  }

  int countForStar(int star) => allReviews.where((r) => r.rating == star).length;

  void setStarFilter(int star) {
    starFilter = star;
    filteredReviews = star == 0
        ? List.from(allReviews)
        : allReviews.where((r) => r.rating == star).toList();
    update();
  }

  void deleteReview(String id) {
    allReviews.removeWhere((r) => r.id == id);
    setStarFilter(starFilter);
  }
}