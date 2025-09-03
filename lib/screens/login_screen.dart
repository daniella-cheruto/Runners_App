import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // TODO: Implement your login logic
    print("Email: ${_emailController.text}, Password: ${_passwordController.text}");
  }

  void _goToRegister() {
    // TODO: Navigate to Register screen
  }

  void _forgotPassword() {
    // TODO: Navigate to Forgot Password screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.black,
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

              // Register Button (white)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _goToRegister,
                  child: const Text("Register", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 12),

              // Forgot Password
              TextButton(
                onPressed: _forgotPassword,
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.purple, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
