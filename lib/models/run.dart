import 'package:cloud_firestore/cloud_firestore.dart'; // <-- needed for Timestamp

class RunModel {
  final String id;        // Unique run ID
  final String userId;    // Which user did the run
  final String routeId;   // Which route they used
  final double distance;  // Distance covered in km
  final int duration;     // Duration in minutes
  final DateTime date;    // When the run happened

  RunModel({
    required this.id,
    required this.userId,
    required this.routeId,
    required this.distance,
    required this.duration,
    required this.date,
  });

  factory RunModel.fromMap(Map<String, dynamic> map, String id) {
    // Handle multiple possible types from Firestore/admin tools:
    // Timestamp, DateTime, String (ISO), or int (ms since epoch)
    final raw = map['date'];
    DateTime parsedDate;

    if (raw is Timestamp) {
      parsedDate = raw.toDate();
    } else if (raw is DateTime) {
      parsedDate = raw;
    } else if (raw is String) {
      parsedDate = DateTime.tryParse(raw) ?? DateTime.now();
    } else if (raw is int) {
      // assume millisecondsSinceEpoch
      parsedDate = DateTime.fromMillisecondsSinceEpoch(raw);
    } else {
      parsedDate = DateTime.now();
    }

    return RunModel(
      id: id,
      userId: map['userId'] ?? '',
      routeId: map['routeId'] ?? '',
      distance: (map['distance'] ?? 0).toDouble(),
      duration: (map['duration'] ?? 0) as int,
      date: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'routeId': routeId,
      'distance': distance,
      'duration': duration,
      // Save as Firestore Timestamp for consistency
      'date': Timestamp.fromDate(date),
      // If you prefer server time instead, you can use:
      // 'date': FieldValue.serverTimestamp(),
    };
  }
}
