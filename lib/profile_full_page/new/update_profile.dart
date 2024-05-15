import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUserProfile(String newName, String newUsername, String newPassword) async {
  User? user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');

  try {
    // Update password if newPassword is not empty
    if (newPassword.isNotEmpty) {
      await user!.updatePassword(newPassword);
    }

    // Update display name in Firebase Auth
    await user!.updateProfile(displayName: newName);
    await user.reload();

    // Update user document in Firestore
    await usersRef.doc(user.uid).update({
      'fullName': newName,
      'username': newUsername,
    });

    print("User profile updated successfully.");
  } catch (e) {
    print("An error occurred while updating user profile: $e");
    throw e; // You might want to handle this more gracefully
  }
}
