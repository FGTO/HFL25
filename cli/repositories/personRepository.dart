import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;

String hostNumber = "8081";

class PersonRepository extends DataRepository<Person> {
  PersonRepository([super.filePath = 'data/person.json']);

  @override
  Person fromJson(Map<String, dynamic> json) => Person.fromJson(json);

  @override
  Map<String, dynamic> toJson(Person item) => item.toJson();

// CREATE operation
  @override
  Future<Person> create(Person person) async {
    try {
      // stdout.writeln("Before calling server");
      final url = Uri.parse("http://localhost:8081/adduser");

      String jsonBody = jsonEncode(person.toJson());

      Response response = await http
          .post(url,
              headers: {'Content-Type': 'application/json'}, 
              body: jsonBody)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception("Failed to add person: ${response.statusCode}");
      }

      final json = jsonDecode(response.body);

      return Person.fromJson(json);
    } catch (e, stackTrace) {
      stderr.writeln("Error in create method: $e");
      stderr.writeln(stackTrace);
      rethrow;
    }
  }

  // READ operation
  @override
  Future<List<Person>> getAll() async {
    final url = Uri.parse("http://localhost:$hostNumber/getusers");

    // stdout.writeln("Before get request");
    final response = await http.get(url);
    // stdout.writeln("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(response.body); // Decode JSON string

      return jsonData
          .map((e) =>
              Person.fromJson(e as Map<String, dynamic>)) // Ensure correct type
          .toList();
    } else {
      throw Exception("Failed to load users: ${response.statusCode}");
    }
  }

// Get user by id
  Future<Person?> getById(String id) async {
    final url = Uri.parse("http://localhost:$hostNumber/getuser/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Person.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null; // Return null if user is not found
    } else {
      throw Exception("Failed to load user: ${response.statusCode}");
    }
  }

  // UPDATE operation
  @override
  Future<void> update(String personId, Person updateObject) async {
    final url = Uri.parse("http://localhost:8081/updateuser/$personId");

    print("Sending PATCH request to update person with ID: $personId");
    print("Payload: ${json.encode(updateObject)}");

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(updateObject),
      );

      print("Received response status: ${response.statusCode}");
      print("Server response: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Person with ID $personId updated successfully.");
      } else {
        print("❌ Failed to update person: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Error during PATCH request: $e");
    }
  }

// DELETE operation
  @override
  Future<void> delete(String id) async {
    final url = Uri.parse("http://localhost:$hostNumber/deleteuser/$id");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print("✅ Person with ID $id deleted successfully.");
      } else {
        final errorMessage =
            response.body.isNotEmpty ? response.body : "Unknown error";
        print(
            "❌ Failed to delete person: ${response.statusCode}): $errorMessage");
      }
    } catch (e) {
      print("❌ Exception occurered while deleting person: $e");
    }
  }

  @override
  String getId(Person person) {
    return person.personId;
  }

// Local update operation
  /* @override
  Future<void> update(String personId, Person updateObject) async {
    var persons = await getAll();

    // Debugging: Print all loaded persons
    print("✅ Loaded persons:");
    for (var person in persons) {
      print("Person ID: ${person.personId}, UUID: ${person.personUuid}");
    }

    // Find index of the person
    final index = persons.indexWhere((person) => person.personId == personId);

    if (index == -1) {
      print("❌ Person with ID $personId not found.");
      return;
    }

    print("✅ Person found at index: $index");

    persons[index] = updateObject;
    saveAll(persons);
    print("✅ Update successful!");
  } */
}
