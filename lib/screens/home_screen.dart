import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String> _getUserName(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return data["full_name"] ?? "Runner";
    }
    return "Runner";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Runner Dashboard"),
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 210, 189, 214), Color.fromARGB(255, 248, 245, 246)], // Purple → Pink
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // move welcome text higher
              FutureBuilder<String>(
                future:
                    user != null ? _getUserName(user.uid) : Future.value("Runner"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final name = snapshot.data ?? "Runner";
                  return Text(
                    "Welcome, $name",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 30), // space between text and grid

              // Grid of action buttons
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.directions_run,
                      label: "Start Run",
                      route: '/start-run',
                      color: Colors.deepPurple,
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.map,
                      label: "View Safe Routes",
                      route: '/routes',
                      color: Colors.teal,
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.feedback,
                      label: "Community Feedback",
                      route: '/feedback',
                      color: Colors.orange,
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.person,
                      label: "Profile",
                      route: '/profile',
                      color: Colors.pink,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required Color color,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        color: color.withAlpha((0.9 * 255).round()),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
