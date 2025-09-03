class RouteModel {
  final String id;
  final String name;
  final List<Map<String, double>> coordinates; // lat/lng pairs
  final double distance; // in km
  final String safetyRating; // e.g. "Safe", "Moderate", "Unsafe"

  RouteModel({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.distance,
    required this.safetyRating,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map, String id) {
    return RouteModel(
      id: id,
      name: map['name'] ?? '',
      coordinates: List<Map<String, double>>.from(map['coordinates'] ?? []),
      distance: (map['distance'] ?? 0).toDouble(),
      safetyRating: map['safetyRating'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'coordinates': coordinates,
      'distance': distance,
      'safetyRating': safetyRating,
    };
  }
}
