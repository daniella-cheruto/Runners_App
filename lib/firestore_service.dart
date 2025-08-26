import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Example: add a document to a collection
  Future<void> addUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).set(data);
  }

  // Example: get a collection
  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').snapshots();
  }
}
