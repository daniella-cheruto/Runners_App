import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _register() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Validate before sending request
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = "Please enter your full name");
      return;
    }
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() => _confirmPasswordError = "Passwords don’t match");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save the full name in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'full_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _passwordError = 'Password is too weak';
        } else if (e.code == 'email-already-in-use') {
          _emailError = 'Email already in use';
        } else if (e.code == 'invalid-email') {
          _emailError = 'Invalid email address';
        } else {
          _emailError = 'Registration failed. Try again.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add, color: Colors.purple, size: 48),
              const SizedBox(height: 8),
              const Text("Create Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // Full Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  errorText: _nameError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 18),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _emailError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  errorText: _passwordError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 18),

              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  errorText: _confirmPasswordError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 18),

              // Register button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _register,
                  child: const Text("Register",
                      style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 12),

              // Back to Login
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
