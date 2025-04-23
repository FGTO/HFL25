import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkapp/components/login_textfield.dart';
import 'package:parkapp/pages/auth_page.dart';
import 'package:parkapp/pages/add_edit_car_page.dart'; // <-- Add this line

class UserInfoPage extends StatefulWidget {
  final User user;

  const UserInfoPage({super.key, required this.user});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final personIdController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    personIdController.addListener(_validateFields);
    addressController.addListener(_validateFields);
    phoneNumController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      isButtonEnabled =
          personIdController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          phoneNumController.text.isNotEmpty;
    });
  }

  void addUserInfo() {
    print("Saving info for: ${widget.user.email}");
    print("UID: ${widget.user.uid}");
    print("Person ID: ${personIdController.text}");
    print("First Name: ${addressController.text}");
    print("Surname: ${phoneNumController.text}");
    // Your save logic here
  }

  @override
  void dispose() {
    personIdController.dispose();
    addressController.dispose();
    phoneNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add edit user page"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
                (route) => false,
              );
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Icon(Icons.person, size: 100, color: Colors.orange),
                const SizedBox(height: 10),
                Text(
                  "User: ${widget.user.email ?? 'No email'}",
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  "UID: ${widget.user.uid}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEditCarPage(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                        const Size.fromHeight(50),
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.orange.shade700;
                        } else if (states.contains(WidgetState.focused)) {
                          return Colors.orange.shade600;
                        }
                        return Colors.orange;
                      }),
                      overlayColor: WidgetStateProperty.all(
                        // ignore: deprecated_member_use
                        Colors.orangeAccent.withOpacity(0.2),
                      ),
                    ),
                    child: const Text("Add or Edit Car"),
                  ),
                ),

                const SizedBox(height: 45),
                Text('Update information'),
                const SizedBox(height: 25),
                LoginTextfield(
                  controller: addressController,
                  hintText: "Address",
                  obsureText: false,
                ),
                const SizedBox(height: 10),
                LoginTextfield(
                  controller: phoneNumController,
                  hintText: "Phone number",
                  obsureText: false,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: isButtonEnabled ? addUserInfo : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Save"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
