import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkapp/components/login_textfield.dart';
import 'package:parkapp/components/signin_button.dart';
import 'package:parkapp/components/signin_logo.dart';
import 'package:parkapp/pages/add_edit_user_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUpUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loading

        final user = credential.user;
        if (user != null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserInfoPage(user: user),
            ),
          );
        }
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        errorDialog("Passwords don't match.");
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      errorDialog(e.message ?? "Registration failed.");
    }
  }

  void errorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text("Registration Error", style: TextStyle(fontSize: 16))),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register page')),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 30),
                Text(
                  "Register new user",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                LoginTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obsureText: false,
                ),
                const SizedBox(height: 10),
                LoginTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obsureText: true,
                ),
                const SizedBox(height: 10),
                LoginTextfield(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obsureText: true,
                ),
                const SizedBox(height: 15),
                SignInButton(buttonText: "Sign up", onTap: signUpUser),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 5, color: Colors.grey[400])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("or sign in with...", style: TextStyle(color: Colors.grey[700])),
                    ),
                    Expanded(child: Divider(thickness: 5, color: Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SigninLogo(imagePath: 'lib/images/apple.png'),
                    SizedBox(width: 10),
                    SigninLogo(imagePath: 'lib/images/google.png'),
                    SizedBox(width: 10),
                    SigninLogo(imagePath: 'lib/images/facebook.png'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("A member already?", style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login here",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
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
}
