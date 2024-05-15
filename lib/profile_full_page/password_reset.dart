import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Login_Feature/forgotpass_page.dart';


class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Old Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter your old password' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "New Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter your new password' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _resetPassword(context),
                    child: const Text('Confirm Reset'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to the Forgot Password Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotpassScreen()),
                      );
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: FirebaseAuth.instance.currentUser!.email!,
            password: _oldPasswordController.text
        );

        await userCredential.user!.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset successfully!')));
        _oldPasswordController.clear();
        _newPasswordController.clear();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to reset password: ${e.message}')));
      }
    }
  }
}

