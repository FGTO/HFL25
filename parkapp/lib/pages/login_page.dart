import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkapp/components/login_textfield.dart';
import 'package:parkapp/components/signin_button.dart';
import 'package:parkapp/components/signin_logo.dart';
import 'package:parkapp/pages/parking_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Textfield controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign in user method
// Sign in user method
void signInUser() async {
  // Sign in progress indicator
  showDialog(
    context: context,
    builder: (context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  try {
    // Attempt to sign in the user
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;
    Navigator.pop(context);  // Dismiss loading dialog

    // Navigate to the parking page after successful sign-in
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ParkingPage()), // Replace with your actual ParkingPage
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    Navigator.pop(context);  // Dismiss loading dialog
    errorDialog(e.code);  // Show error dialog
  }
}

  // Dialog for wrong email
  void errorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Error when trying login',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 75),
                  //Logotype
                  const Icon(Icons.lock, size: 100),
                  // Top container with centered image
                  const SizedBox(height: 50),
                  //Welcome text
                  Text(
                    "Welcome to ParkingApp",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  // Username
                  LoginTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obsureText: false,
                  ),

                  // Password
                  const SizedBox(height: 10),
                  LoginTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    obsureText: true,
                  ),

                  // Forgot password?
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  // Sign-in button
                  const SizedBox(height: 15),
                  SignInButton(buttonText: 'Sign in', onTap: signInUser),

                  // Alternative sign-in
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 5, color: Colors.grey[400]),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "or sign in with...",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),

                        Expanded(
                          child: Divider(thickness: 5, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Apple
                      SigninLogo(imagePath: 'lib/images/apple.png'),
                      const SizedBox(width: 10),
                      // Google
                      SigninLogo(imagePath: 'lib/images/google.png'),
                      const SizedBox(width: 10),
                      // Facebook
                      SigninLogo(imagePath: 'lib/images/facebook.png'),
                    ],
                  ),

                  // Register new user
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
