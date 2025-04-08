import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

import 'parkingRepository.dart';

class ParkingspaceRepository extends DataRepository<Parkingspace> {
  ParkingspaceRepository([super.filePath = 'storage/parkingspace.json']);

  @override
  Parkingspace fromJson(Map<String, dynamic> json) =>
      Parkingspace.fromJson(json);

  @override
  Map<String, dynamic> toJson(Parkingspace item) => item.toJson();

  @override
  Future<Parkingspace> create(Parkingspace parkingspace) async {
    try {
      final url = Uri.parse("http://localhost:$hostNumber/addparkingspace");
      String jsonBody = jsonEncode(parkingspace.toJson());
      Response response = await http
          .post(url,
              headers: {'Content-Type': 'application/json'}, body: jsonBody)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception("Failed to add parking space: ${response.statusCode}");
      }
      final json = jsonDecode(response.body);

      return Parkingspace.fromJson(json);
    } catch (e, stackTrace) {
      stderr.writeln("Error in create method: $e");
      stderr.writeln(stackTrace);
      rethrow;
    }
  }

// GetAll
// READ operation
  @override
  Future<List<Parkingspace>> getAll() async {
    final url = Uri.parse("http://localhost:$hostNumber/getparkingspaces");

    final response = await http.get(url);
    // stdout.writeln("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(response.body); // Decode JSON string

      return jsonData
          .map((e) => Parkingspace.fromJson(
              e as Map<String, dynamic>)) // Ensure correct type
          .toList();
    } else {
      throw Exception("Failed to load users: ${response.statusCode}");
    }
  }

  Future<Parkingspace?> getSpaceById(String id) async {
    final parkingspaces = await getAll();

    for (var parkingspace in parkingspaces) {
      if (parkingspace.parkingSpaceId.trim().toLowerCase() ==
          id.trim().toLowerCase()) {
        return parkingspace;
      }
    }
    return null;
  }

  @override
  String getId(Parkingspace parkingspace) {
    return parkingspace.parkingSpaceId;
  }
}
