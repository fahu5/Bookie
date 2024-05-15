import 'package:bookiee/Login_Feature/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Core/Animation/fade_animation.dart';
import '../widget/float_navigationbar.dart';
import 'auth_service.dart';
import 'forgotpass_page.dart';



enum FormData {
  email,
  password,
}

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreens> {
  Color enabled = const Color(0xFF454A64);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.white70;
  Color backgroundColor = const Color(0xFFBA68CF).withOpacity(0.9);
  bool isPasswordVisible = true;
  FormData? selected;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Navigate to the homepage screen upon successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationMenu(),),
      );
    } catch (e) {
      print('Error signing in: $e');
      // Handle authentication error (e.g., show error message to the user)
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              const Color(0xFFCE93D8).withOpacity(0.8),
              const Color(0xFFBA68C8).withOpacity(0.8),
              const Color(0xFFBA68C8),
              const Color(0xFFBA68C8),
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0x000fffff).withOpacity(0.2),
              BlendMode.dstATop,
            ),
            image: const AssetImage("assets/login_screen_pic.png"),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bookie',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Card(
                  elevation: 5,
                  color: const Color(0xFFCE93D8).withOpacity(0.4),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeAnimation(
                          delay: 1.0,
                          child: Image.asset(
                            "assets/login_screen_pic.png",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const FadeAnimation(
                          delay: 1.0,
                          child: Text(
                            "Please sign in to continue",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        buildInputField(
                          controller: emailController,
                          hint: 'Email',
                          icon: Icons.email_outlined,
                          type: FormData.email,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildPasswordInputField(
                          controller: passwordController,
                          hint: 'Password',
                          type: FormData.password,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const NavigationMenu(),
                              )

                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF91D3B9),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotpassScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3.0,
                            horizontal: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                        child: const Text(
                          "Can't remember password?",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                const FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Not a member?sign up with",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'assets/google.png'
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FormData type,
  }) {
    return FadeAnimation(
      delay: 1,
      child: Container(
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: selected == type ? enabled : backgroundColor,
        ),
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: controller,
          onTap: () {
            setState(() {
              selected = type;
            });
          },
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: selected == type ? enabledtxt : deaible,
              size: 20,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: selected == type ? enabledtxt : deaible,
              fontSize: 12,
            ),
          ),
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: selected == type ? enabledtxt : deaible,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordInputField({
    required TextEditingController controller,
    required String hint,
    required FormData type,
  }) {
    return FadeAnimation(
      delay: 1,
      child: Container(
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: selected == type ? enabled : backgroundColor,
        ),
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: controller,
          onTap: () {
            setState(() {
              selected = type;
            });
          },
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: selected == type ? enabledtxt : deaible,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? Icon(
                Icons.visibility_off,
                color: selected == type ? enabledtxt : deaible,
                size: 20,
              )
                  : Icon(
                Icons.visibility,
                color: selected == type ? enabledtxt : deaible,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: selected == type ? enabledtxt : deaible,
              fontSize: 12,
            ),
          ),
          obscureText: !isPasswordVisible,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: selected == type ? enabledtxt : deaible,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
