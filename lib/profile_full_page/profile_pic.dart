import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profilepic extends StatefulWidget {
  const Profilepic({Key? key}) : super(key: key);

  @override
  _ProfilepicState createState() => _ProfilepicState();
}

class _ProfilepicState extends State<Profilepic> {
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: const Text('Change Profile Picture'),
            ),
          ],
        ),
      ),
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
      final ref = firebase_storage.FirebaseStorage.instance.ref('images/$fileName');
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
      final userId = user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'photoURL': imageUrl,
      });
      print('Image URL saved to Firestore');
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
    }
  }

  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Error fetching user data');
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;

        if (userData == null || !userData.containsKey('photoURL')) {
          return const CircleAvatar(
            radius: 60,
            child: Icon(Icons.person, size: 60),
          );
        }

        final String imageUrl = userData['photoURL'];

        return CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(imageUrl),
          key: UniqueKey(),
        );
      },
    );
  }
}
