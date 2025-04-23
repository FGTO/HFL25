import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart'; // Import ParkingSpace model here

// Dummy host number for now; change it as needed
const int hostNumber = 8081;

class ParkingSpacePage extends StatefulWidget {
  final Parking parking;  // Parking object passed from ParkingPage

  const ParkingSpacePage({super.key, required this.parking});

  @override
  ParkingSpacePageState createState() => ParkingSpacePageState(); 
}

class ParkingSpacePageState extends State<ParkingSpacePage> { 
  late Future<List<Parkingspace>> _parkingSpaces;

  // Fetch ParkingSpace data from the server
  Future<List<Parkingspace>> fetchParkingSpaces() async {
    final url = Uri.parse("http://localhost:$hostNumber/getparkingspaces");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<Parkingspace> allParkingSpaces = jsonData.map((e) => Parkingspace.fromJson(e)).toList();

      // Filter the parking spaces that belong to the selected parking (by parkingId)
      return allParkingSpaces.where((space) => space.parkingId == widget.parking.parkingId).toList();
    } else {
      throw Exception("Failed to load parking spaces: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch parking spaces related to the selected parking
    _parkingSpaces = fetchParkingSpaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking space page')),
      body: FutureBuilder<List<Parkingspace>>(
        future: _parkingSpaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No parking spaces found."));
          }

          final parkingSpaces = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: parkingSpaces.length,
            itemBuilder: (context, index) {
              final space = parkingSpaces[index];
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: Icon(
                    space.isOccupied ? Icons.car_crash : Icons.no_crash,
                    color: space.isOccupied ? Colors.red : Colors.green,
                    size: 32,
                  ),
                  title: Text(space.number), // assuming ParkingSpace has 'number'
                  subtitle: Text(
                    space.isOccupied ? 'Occupied' : 'Available',
                    style: TextStyle(color: space.isOccupied ? Colors.red : Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
