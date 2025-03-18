import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

String hostNumber = "8081";
class ParkingRepository extends DataRepository<Parking> {
  ParkingRepository([super.filePath = 'storage/parking.json']);

  @override
  Parking fromJson(Map<String, dynamic> json) => Parking.fromJson(json);

  @override
  Map<String, dynamic> toJson(Parking item) => item.toJson();

// READ operation
  @override
  Future<List<Parking>> getAll() async {
    final url = Uri.parse("http://localhost:$hostNumber/getparking");

    // stdout.writeln("Before get request");
    final response = await http.get(url);
    // stdout.writeln("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(response.body); // Decode JSON string

      return jsonData
          .map((e) =>
              Parking.fromJson(e as Map<String, dynamic>)) // Ensure correct type
          .toList();
    } else {
      throw Exception("Failed to load users: ${response.statusCode}");
    }
  }

  Future<Parking?> getParkingById(String id) async {
    final url = Uri.parse("http://localhost:$hostNumber/getparking/$id");
    final response = await http.get(url);

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Parking.fromJson(jsonData);
    } else if(response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Failed to load parking: ${response.statusCode}");
    }
  }
 
  @override
  String getId(Parking parking) {
    return parking.parkingId;
  }
}
