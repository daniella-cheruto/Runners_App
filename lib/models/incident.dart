class IncidentModel {
  final String id;
  final String userId;
  final String description;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final DateTime reportedAt;

  IncidentModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    required this.reportedAt,
  });

  factory IncidentModel.fromMap(Map<String, dynamic> map, String id) {
    return IncidentModel(
      id: id,
      userId: map['userId'] ?? '',
      description: map['description'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      photoUrl: map['photoUrl'],
      reportedAt: DateTime.tryParse(map['reportedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'photoUrl': photoUrl,
      'reportedAt': reportedAt.toIso8601String(),
    };
  }
}
