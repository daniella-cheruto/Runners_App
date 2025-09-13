import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _preferredTimeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  File? _profileImage;

  // Inline error messages
  String _statusMessage = "";
  String? _nameError;
  String? _dobError;
  String? _genderError;
  String? _locationError;
  String? _experienceError;
  String? _preferredTimeError;
  String? _weightError;
  String? _heightError;
  String? _emergencyContactError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['full_name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _dobController.text = data['dob'] ?? '';
          _genderController.text = data['gender'] ?? '';
          _locationController.text = data['location'] ?? '';
          _experienceController.text = data['experience'] ?? '';
          _preferredTimeController.text = data['preferred_time'] ?? '';
          _weightController.text = data['weight'] ?? '';
          _heightController.text = data['height'] ?? '';
          _emergencyContactController.text = data['emergency_contact'] ?? '';
        });
      }
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  bool _validateFields() {
    bool valid = true;

    setState(() {
      _nameError = _nameController.text.trim().isEmpty ? "Required" : null;
      _dobError = _dobController.text.trim().isEmpty ? "Required" : null;
      _genderError = _genderController.text.trim().isEmpty ? "Required" : null;
      _locationError = _locationController.text.trim().isEmpty ? "Required" : null;
      _experienceError = _experienceController.text.trim().isEmpty ? "Required" : null;
      _preferredTimeError = _preferredTimeController.text.trim().isEmpty ? "Required" : null;
      _weightError = _weightController.text.trim().isEmpty ? "Required" : null;
      _heightError = _heightController.text.trim().isEmpty ? "Required" : null;
      _emergencyContactError = _emergencyContactController.text.trim().isEmpty ? "Required" : null;

      if (_nameError != null ||
          _dobError != null ||
          _genderError != null ||
          _locationError != null ||
          _experienceError != null ||
          _preferredTimeError != null ||
          _weightError != null ||
          _heightError != null ||
          _emergencyContactError != null) {
        valid = false;
      }
    });

    return valid;
  }

  Future<void> _saveProfile() async {
    if (!_validateFields()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        'full_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _dobController.text.trim(),
        'gender': _genderController.text.trim(),
        'location': _locationController.text.trim(),
        'experience': _experienceController.text.trim(),
        'preferred_time': _preferredTimeController.text.trim(),
        'weight': _weightController.text.trim(),
        'height': _heightController.text.trim(),
        'emergency_contact': _emergencyContactController.text.trim(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        _statusMessage = "Profile updated successfully ✅";
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                backgroundColor: Colors.purple.withAlpha(153),
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),

            _buildTextField(
                controller: _nameController, label: "Full Name", errorText: _nameError),
            _buildTextField(
                controller: _emailController,
                label: "Email (read-only)",
                readOnly: true),
            _buildTextField(
                controller: _dobController, label: "Date of Birth", errorText: _dobError),
            _buildTextField(
                controller: _genderController, label: "Gender", errorText: _genderError),
            _buildTextField(
                controller: _locationController,
                label: "Neighborhood (Nairobi)",
                errorText: _locationError),
            _buildTextField(
                controller: _experienceController,
                label: "Running Experience Level",
                errorText: _experienceError),
            _buildTextField(
                controller: _preferredTimeController,
                label: "Preferred Running Time",
                errorText: _preferredTimeError),
            _buildTextField(
                controller: _weightController, label: "Weight (kg)", errorText: _weightError),
            _buildTextField(
                controller: _emergencyContactController,
                label: "Emergency Contact",
                errorText: _emergencyContactError),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Save Profile", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
