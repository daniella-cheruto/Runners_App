import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/route.dart';
import '../models/run.dart';
import '../models/feedback.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ---------------- USERS ----------------
  Future<void> addUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Stream<List<UserModel>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// ---------------- ROUTES ----------------
  Future<void> addRoute(RouteModel route) async {
    await _db.collection('routes').doc(route.id).set(route.toMap());
  }

  Stream<List<RouteModel>> getRoutes() {
    return _db.collection('routes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => RouteModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// ---------------- RUNS ----------------
  Future<void> addRun(RunModel run) async {
    await _db.collection('runs').doc(run.id).set(run.toMap());
  }

  Stream<List<RunModel>> getRunsForUser(String userId) {
    return _db
        .collection('runs')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => RunModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// ---------------- FEEDBACK ----------------
  Future<void> addFeedback(FeedbackModel feedback) async {
    await _db.collection('feedback').doc(feedback.id).set(feedback.toMap());
  }

  Stream<List<FeedbackModel>> getFeedbackForRoute(String routeId) {
    return _db
        .collection('feedback')
        .where('routeId', isEqualTo: routeId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FeedbackModel.fromMap(doc.data(), doc.id)).toList());
  }
}
