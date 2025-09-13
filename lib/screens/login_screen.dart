import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  void _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    //  Local validation first
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Email required';
      });
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = 'Password required';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _emailError = 'Email not found';
        } else if (e.code == 'wrong-password') {
          _passwordError = 'Incorrect password';
        } else {
          _passwordError = 'Incorrect password';
        }
      });
    }
  }

  void _goToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // take full height
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo + Name
                      const Icon(Icons.directions_run, color: Colors.purple, size: 48),
                      const SizedBox(height: 8),
                      const Text(
                        "Runner",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 30),

                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorText: _emailError,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.purple, width: 1.5),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 18),

                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorText: _passwordError,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.purple, width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Login Button
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
                          onPressed: _login,
                          child: const Text("Login", style: TextStyle(fontSize: 16)),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: const BorderSide(color: Colors.purple, width: 1.5),
                          ),
                          onPressed: _goToRegister,
                          child: const Text("Register", style: TextStyle(fontSize: 16)),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Forgot Password
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
