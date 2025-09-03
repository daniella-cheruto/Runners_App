class FeedbackModel {
  final String id;
  final String userId;
  final String routeId;
  final String comment;
  final int rating; // 1–5 stars
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.routeId,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String id) {
    return FeedbackModel(
      id: id,
      userId: map['userId'] ?? '',
      routeId: map['routeId'] ?? '',
      comment: map['comment'] ?? '',
      rating: map['rating'] ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'routeId': routeId,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
