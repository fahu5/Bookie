import 'package:bookiee/profile_full_page/password_reset.dart';
import 'package:bookiee/profile_full_page/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController(); // Controller for bio

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    // Load user data from Firestore
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    _usernameController.text = userData['username'] ?? user?.email ?.split('@').first ?? "";

  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text('Account Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(height: 6),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Username", _usernameController),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _updateProfile(context),
                      child: const Text("Update Information"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const PasswordReset(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _updateProfile(BuildContext context) async {
    if (_usernameController.text.isNotEmpty) {
      try {
        await user!.updateDisplayName(_usernameController.text);
        await FirebaseFirestore.instance.collection('users')
            .doc(user!.uid)
            .update({
          'username': _usernameController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')));
    }
  }

}