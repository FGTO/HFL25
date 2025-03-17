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

// CREATE
  @override
  Future<Vehicle> create(Vehicle vehicle) async {
    try {
      final url = Uri.parse("http://localhost:8081/addvehicle");

      String jsonBody = jsonEncode(vehicle.toJson());
      stdout.writeln(jsonBody.toString());
      Response response = await http
          .post(url,
              headers: {'Content-Type': 'application/json'}, body: jsonBody)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to add vehicle: ${response.statusCode}');
      }

      final json = jsonDecode((response.body));

      return Vehicle.fromJson(json);
    } catch (e, stackTrace) {
      stderr.write("Error in create method: $e");
      stderr.writeln(stackTrace);
      rethrow;
    }
  }

// READ
  @override
  Future<List<Vehicle>> getAll() async {
    final url = Uri.parse("http://localhost:$hostNumber/getvehicles");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData
          .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to load vehicles: ${response.statusCode}");
    }
  }

// GET vehicle by id
  Future<Vehicle?> getVehicleById(String id) async {
    final url = Uri.parse("http://localhost:$hostNumber/getvehicle/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Vehicle.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(("Failed to load vehicle: ${response.statusCode}"));
    }
  }

// UPDATE
  Future<void> updateVehicle(String regNum, Vehicle updateObject) async {
    final url = Uri.parse("http://localhost:$hostNumber/updatevehicle/$regNum");
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateObject),
      );

      if (response.statusCode == 200) {
        print(
            "✅ Vehicle with registration number $regNum updated successfully.");
      } else {
        print("❌ Failed to update vehicle: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during vehicle update request");
    }
  }

// DELETE
  Future<void> deleteVehicle(String id) async {
    final url = Uri.parse("http://localhost:$hostNumber/deletevehicle/$id");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print("✅ Vehicle with registration number $id deleted successfully.");
      } else {
        final errorMessage =
            response.body.isNotEmpty ? response.body : "Unknown error";
        print(
            "❌ Failed to delete vehicle: ${response.statusCode}): $errorMessage");
      }
    } catch (e) {
      print("❌ Exception occurered while deleting vehicle: $e");
    }
  }

  /*Future<Vehicle?> getVehicleById(String id) async {
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
*/
  @override
  String getId(Vehicle vehicle) {
    return vehicle.licensePlate; // Ensure `Person` has an `id` property
  }
}
