class MyReviewModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final int rating;
  final DateTime date;
  final String comment;
  final List<String> images;

  MyReviewModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.rating,
    required this.date,
    required this.comment,
    this.images = const [],
  });
}