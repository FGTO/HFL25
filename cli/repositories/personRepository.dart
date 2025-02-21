import 'dart:convert';
import 'dart:io';

import 'package:shared/shared.dart';

class PersonRepository extends DataRepository<Person> {
  PersonRepository([super.filePath = 'storage/person.json']);

  @override
  Person fromJson(Map<String, dynamic> json) => Person.fromJson(json);

  @override
  Map<String, dynamic> toJson(Person item) => item.toJson();

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

  @override
  Future<List<Person>> getAll() async {
    final file = File(filePath);
    if (!file.existsSync()) return [];
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .map((e) => e != null ? Person.fromJson(e) : null)
        .whereType<Person>()
        .toList();
  }

  @override
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
  }
}
