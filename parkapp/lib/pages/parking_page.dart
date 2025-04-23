import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkapp/pages/auth_page.dart';
import 'package:shared/shared.dart';
import 'parking_space_page.dart';
import 'add_edit_user_page.dart';
// Dummy host number for now; change it as needed
const int hostNumber = 8081;

class ParkingPage extends StatelessWidget {
  ParkingPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign out user and navigate to LoginPage
 void signUserOut(BuildContext context) {
  FirebaseAuth.instance.signOut();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const AuthPage()),
  );
}


  // Fetch parking spaces
  Future<List<Parking>> getAll() async {
    final url = Uri.parse("http://localhost:$hostNumber/getparkings");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Parking.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load parking spaces: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    
  leading: IconButton(
    icon: Icon(Icons.person),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPage(user: user),
        ),
      );
    },
  ),
  title: Text("Parking page : Welcome, ${user.email}"),
  actions: [
    IconButton(
      onPressed: () => signUserOut(context),
      icon: Icon(Icons.logout),
    ),
  ],
),

      body: FutureBuilder<List<Parking>>(
        future: getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No parking spaces available."));
          }

          final parkings = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemCount: parkings.length,
            itemBuilder: (context, index) {
              final space = parkings[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingSpacePage(parking: space),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: Icon(
                      Icons.local_parking,
                      color: Colors.green,
                      size: 32,
                    ),
                    title: Text(
                      space.location,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      space.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
