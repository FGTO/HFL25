import 'dart:convert';
// import 'dart:io';

import 'package:http/http.dart';
import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;

String hostNumber = "8081";

class PersonRepository extends DataRepository<Person> {
  PersonRepository([super.filePath = 'storage/person.json']);

  @override
  Person fromJson(Map<String, dynamic> json) => Person.fromJson(json);

  @override
  Map<String, dynamic> toJson(Person item) => item.toJson();

// CREATE operation
  @override
  Future<Person> create(Person person) async {
    final url = Uri.parse("https://localhost:8081/adduser");
    Response response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()));

    final json = await jsonDecode(response.body);
    return Person.fromJson(json);
  }

  // READ operation
  @override
  Future<List<Person>> getAll() async {
    final url = Uri.parse("https://localhost:${hostNumber}/getusers");
    final response = await http.get(url);

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

  // UPDATE operation
  @override
  Future<void> update(String id, Person updatedPerson) async {
    final url = Uri.parse("https://localhost:${hostNumber}/updateuser/$id");
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedPerson.toJson()),
    );
    if (response.statusCode == 200) {
      print("✅ Person updated successfully.");
    } else {
      throw Exception("❌ Failed to update person: ${response.statusCode}");
    }
  }

// DELETE operation
  Future<Person?> getPersonById(String id) async {
    final persons = await getAll();

    for (var person in persons) {
      if (person.personId.trim().toLowerCase() == id.trim().toLowerCase()) {
        return person;
      }
    }
    return null;
  }

  @override
  String getId(Person person) {
    return person.personId;
  }

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
