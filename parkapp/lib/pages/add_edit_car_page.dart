import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Dummy Vehicle model – replace with your real model
class Vehicle {
  final String vehicleId;
  final String ownerId;
  final String licensePlate;
  final String model;
  final String? parkingSpaceId;
  final String? vehicleType;
  
  Vehicle({
    required this.vehicleId,
    required this.ownerId,
    required String licensePlate, // Use setter-like logic
    required String model, // Use setter-like logic
    String? parkingSpaceId,
    this.vehicleType
  }) : licensePlate = licensePlate.toLowerCase(),
       model = model.toLowerCase(),
       parkingSpaceId = parkingSpaceId?.toLowerCase(); 

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'],
      ownerId: json['ownerId'],
      licensePlate: json['licensePlate'],
      model: json['model'],
      parkingSpaceId: json['parkingSpaceId'],
      vehicleType:json['vehicletype']
    );
  }
  }

class AddEditCarPage extends StatefulWidget {
  const AddEditCarPage({super.key});

  @override
  State<AddEditCarPage> createState() => _AddEditCarPageState();
}

class _AddEditCarPageState extends State<AddEditCarPage> {
  late Future<List<Vehicle>> _vehiclesFuture;
  final String uid = "c0LX6sDWvYX8TgFeHSbow5uaUVO2";
  final int hostNumber = 8081;

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = getAllVehicles();
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final url = Uri.parse("http://localhost:$hostNumber/getvehicles");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
          .where((vehicle) => vehicle.ownerId == uid)
          .toList();
    } else {
      throw Exception("Failed to load vehicles: ${response.statusCode}");
    }
  }

  void onEdit(Vehicle vehicle) {
    // Navigate to edit page or show dialog
    print("Edit vehicle: ${vehicle.vehicleId}");
  }

  void onDelete(Vehicle vehicle) {
    // Implement delete logic
    print("Delete vehicle: ${vehicle.vehicleId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add edit car page")),
      body: FutureBuilder<List<Vehicle>>(
        future: _vehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No vehicles found."));
          }

          final vehicles = snapshot.data!;
          return ListView.builder(
            itemCount: vehicles.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    vehicle.licensePlate.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '(${vehicle.vehicleType ?? "Unknown type"})',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onEdit(vehicle),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDelete(vehicle),
                      ),
                    ],
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
