import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get currently logged-in user
  User? get currentUser => _auth.currentUser;

  // Sign up with email & password
  Future<UserModel?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user object
      UserModel user = UserModel(
        id: result.user!.uid,
        name: name,
        email: email,
      );

      return user;
    } catch (e) {
      print("SignUp Error: $e");
      return null;
    }
  }

  // Login with email & password
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserModel(
        id: result.user!.uid,
        name: result.user!.displayName ?? '',
        email: result.user!.email ?? '',
      );
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
