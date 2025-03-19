import 'dart:convert';
import 'dart:io';

import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;


String hostNumber = "8081";

class ParkingRepository extends DataRepository<Parking> {
  ParkingRepository([super.filePath = 'data/parking.json']);

  @override
  Parking fromJson(Map<String, dynamic> json) => Parking.fromJson(json);

  @override
  Map<String, dynamic> toJson(Parking item) => item.toJson();

// CREATE operation
  @override
  Future<Parking> create(Parking parking) async {
    try {
      final url = Uri.parse("http://localhost:$hostNumber/addparking");

      String jsonBody = jsonEncode(parking.toJson());

      http.Response response = await http
          .post(url,
              headers: {'Content-Type': 'application/json'}, body: jsonBody)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception("Failed to add parking: ${response.statusCode}");
      }
      
      final json = jsonDecode(response.body);

      return Parking.fromJson(json);
    } catch (e, stackTrace) {
      stderr.writeln("Error in creat method: $e");
      stderr.writeln(stackTrace);
      rethrow;
    }
  }

// READ operation
  @override
  Future<List<Parking>> getAll() async {
    final url = Uri.parse("http://localhost:$hostNumber/getparkings");

    final response = await http.get(url);
    // stdout.writeln("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(response.body); // Decode JSON string

      return jsonData
          .map((e) => Parking.fromJson(
              e as Map<String, dynamic>)) // Ensure correct type
          .toList();
    } else {
      throw Exception("Failed to load users: ${response.statusCode}");
    }
  }

// GET parking by id
  Future<Parking?> getParkingById(String id) async {
    final url = Uri.parse("http://localhost:$hostNumber/getparking/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Parking.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Failed to load parking: ${response.statusCode}");
    }
  }

// UPDATE operation
  @override
  Future<void> update(String parkingId, Parking parkingObject) async {
    final url =
        Uri.parse("http://localhost:$hostNumber/updateparking/$parkingId");

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(parkingObject),
      );
      if (response.statusCode == 200) {
        print("✅ Parking with ID $parkingId update successfully");
      } else {
        print("❌ Failed to update parking ${response.statusCode}");
      }
    } catch (e) {
      print("Error during PATCH request: $e");
    }
  }

// DELETE operation
  @override
  Future<void> delete(String id) async {
    final url = Uri.parse("http://localhost:$hostNumber/deleteparking/$id");
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        print("✅ Parking with ID $id deleted successfully.");
      } else {
        final errorMessage =
            response.body.isNotEmpty ? response.body : "Unknown error";
        print(
            "❌ Failed to delete parking: ${response.statusCode}): $errorMessage");
      }
    } catch (e) {
      print("❌ Exception occurered while deleting parking: $e");
    }
  }

  @override
  String getId(Parking parking) {
    return parking.parkingId;
  }
}
