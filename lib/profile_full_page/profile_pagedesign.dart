import 'dart:io';
import 'package:bookiee/profile_full_page/privacy.dart';
import 'package:path/path.dart';

import 'package:bookiee/profile_full_page/profile_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'Theme/ThemeNotifier.dart';
import 'account_settings.dart';
import 'delete.dart';
import 'notification_set.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;
  String email = "No email registered";
  String bio = "";

  File? image;

  @override
  void initState() {
    super.initState();
    final user = this.user;
    if (user != null) {
      email = user.email ?? "No email registered"; // Get email directly from Firebase Auth
    }
  }


  @override
  Widget build(BuildContext context) {
    const icon = CupertinoIcons.moon_stars;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(icon, color: Colors.white),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(height: 16),
          _buildHeader(context),
          const SizedBox(height: 24),
          _infoContainer(context, "Email", email),
          const SizedBox(height: 24),
          ProfileListItem(
            icon: Icons.settings,
            text: 'Account Settings',
            hasNavigation: true,
            iconColor: Colors.black,
            textColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
              );
            },
          ),
          ProfileListItem(
            icon: Icons.notifications,
            text: 'Notification',
            hasNavigation: true,
            iconColor: Colors.black,
            textColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>   NotificationPage()),
              );

            },
          ),
          ProfileListItem(
            icon: Icons.privacy_tip_rounded,
            text: 'Privacy & Policy',
            hasNavigation: true,
            iconColor: Colors.black,
            textColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );

            },
          ),
          const SizedBox(height: 8),
           ProfileListItem(
            icon: Icons.logout,
            text: 'Logout',
            hasNavigation: false,
            iconColor: Colors.black,
            textColor: Colors.black,
            onTap: () => _showLogoutConfirmationDialog(context),
          ),

          const SizedBox(height: 8),
          ProfileListItem(
            icon: Icons.delete_forever,
            text: 'Delete Account',
            hasNavigation: false,
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
    );
  }


  //profile pic
  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Text('No data found');
        }

        Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;

        if (userData == null || !userData.containsKey('username')) {
          return const Text('Username not found in data');
        }

        String username = userData['username'];
        String? userImageUrl = userData['photoURL'];

        return Column(
          children: <Widget>[
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: userImageUrl != null
                        ? NetworkImage(userImageUrl)
                        : const AssetImage("assets/placeholder_image.jpg") as ImageProvider,
                    key: UniqueKey(),
                  ),
                  GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Center(
                        child: Icon(Icons.camera_alt_outlined, color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        _uploadImageToFirebaseStorage();
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> _uploadImageToFirebaseStorage() async {
    if (_photo == null) return;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = firebase_storage.FirebaseStorage.instance.ref('profile_images/$fileName');
      await ref.putFile(_photo!);
      final imageUrl = await ref.getDownloadURL();
      await _saveImageUrlToFirestore(imageUrl);
      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _saveImageUrlToFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'photoURL': imageUrl,
      });
      print('Image URL saved to Firestore');
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
    }
  }

  Future<void> uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occurred');
    }
  }






//profile list
  Widget _infoContainer(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}


  void _showLogoutConfirmationDialog(BuildContext context)  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/signin');  // Assuming '/signin' is your login route
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeleteAccountPage(), // Navigate to DeleteAccountPage
                ));
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
















