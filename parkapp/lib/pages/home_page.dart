import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

// Dummy host number for now; change it as needed
const int hostNumber = 8081;

class Parkingspace {
  final String parkingSpaceId;
  final String number;
  final bool isOccupied;
  final String? vehicleId;
  final String parkingId;

  Parkingspace({
    required this.parkingSpaceId,
    required this.number,
    required this.isOccupied,
    required this.vehicleId,
    required this.parkingId,
  });

  factory Parkingspace.fromJson(Map<String, dynamic> json) {
    return Parkingspace(
      parkingSpaceId: json['parkingSpaceId'] ?? '0', // FIXED key
      number: json['number'] ?? 'Unknown',
      isOccupied: json['isOccupied'] ?? false,
      vehicleId: json['vehicleId'],
      parkingId: json['parkingId'] ?? '2',
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign out user
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Fetch parking spaces
  Future<List<Parkingspace>> getAll() async {
    final url = Uri.parse("http://127.0.0.1:$hostNumber/getparkingspaces");

    final response = await http.get(url);
    // print("response body " + response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      // print("Decoded JSON: $jsonData");
      // print("First item keys: ${jsonData.first}");

      return jsonData.map((e) => Parkingspace.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load parking spaces: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user.email}"),
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
      ),
      body: FutureBuilder<List<Parkingspace>>(
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
              return Container(
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Icon(
                    space.isOccupied ? Icons.car_rental : Icons.local_parking,
                    color: space.isOccupied ? Colors.redAccent : Colors.green,
                    size: 32,
                  ),
                  title: Text(
                    space.number,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    space.isOccupied ? "Occupied" : "Available",
                    style: TextStyle(color: Colors.grey[600]),
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

/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  // Sign out user method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Text(
          'Logged in as ${user.email!}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
 */
