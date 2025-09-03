class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // Convert Firestore data → UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // Convert UserModel → Firestore data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
