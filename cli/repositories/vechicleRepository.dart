import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared/shared.dart';

String hostNumber = "8081";

class VehicleRepository extends DataRepository<Vehicle> {
  VehicleRepository([super.filePath = 'data/vehicle.json']);

  @override
  Vehicle fromJson(Map<String, dynamic> json) => Vehicle.fromJson(json);

  @override
  Map<String, dynamic> toJson(Vehicle item) => item.toJson();

// TODO CREATE
Future<Vehicle> create(Vehicle vehicle) async {
  try{
    final url = Uri.parse("http://localhost:$hostNumber/addvehicle");

    String jsonBody = jsonEncode(vehicle.toJson());

    Response response = await http
      .post(url,
        headers: {'Content-Type' : 'application/json'}, 
        body: jsonBody)
      .timeout(const Duration(seconds: 10));

      if(response.statusCode != 200){
        throw Exception('Failed to add vehicle: ${response.statusCode}');
      }

      final json = jsonDecode((response.body));

      return Vehicle.fromJson(json);
  } catch (e, stackTrace){
    stderr.write("Error in create method: $e");
    stderr.writeln(stackTrace);
    rethrow;
  }
  }

// TODO READ

// TODO GET by id

// TODO UPDATE

// TODO DELETE

  Future<Vehicle?> getVehicleById(String id) async {
    final vehicles = await getAll();

    print("Searching for: '$id'");
    print("Available IDs: ${vehicles.map((p) => p.licensePlate).toList()}");

    for (var vehicle in vehicles) {
      // print("Comparing '${person.personId}' with '$id'");
      if (vehicle.licensePlate.toLowerCase().trim() ==
          id.trim().toLowerCase()) {
        return vehicle; // Found the person, return it.
      }
    }

    // print("Person with ID '$id' not found.");
    return null; // Explicitly return null.
  }

  @override
  String getId(Vehicle vehicle) {
    return vehicle.licensePlate; // Ensure `Person` has an `id` property
  }
}