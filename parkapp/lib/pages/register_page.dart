import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkapp/components/login_textfield.dart';
import 'package:parkapp/components/signin_button.dart';
import 'package:parkapp/components/signin_logo.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Textfield controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign in user method
  void signUpUser() async {
    // Sign in progress indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {

    // Check if passwrd == confirm password
    if(passwordController.text == confirmPasswordController.text){

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } else {
      errorDialog('Passwords don\'t match.');
    }

      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      errorDialog(e.code);
    }
  }

  // Dialog for wrong email
void errorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(child: Text('Error when trying login',
        style: TextStyle(fontSize: 16.0),)),
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

  /*   // Dialog for incorrect password
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Wrong password'),
          content: Text('The password you entered is incorrect.'),
        );
      },
    );
  }

  void tooManyRequestsMessage() {
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(
        title: Text('Too many attempts'),
        content: Text(
          'You’ve made too many login attempts. Please try again later.',
        ),
      );
    },
  );
} */

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
                  const SizedBox(height: 40),
                  //Logotype
                  const Icon(Icons.lock, size: 100),
                  // Top container with centered image
                  const SizedBox(height: 30),
                  //Welcome text
                  Text(
                    "Register new user",
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

// Confirm password
                  const SizedBox(height: 10),
                  LoginTextfield(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obsureText: true,
                  ),


                 /*  // Forgot password?
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
                  ), */

                  // Sign-in button
                  const SizedBox(height: 15),
                  SignInButton(buttonText: 'Sign up', onTap: signUpUser),

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
                        'A member already?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login here',
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
