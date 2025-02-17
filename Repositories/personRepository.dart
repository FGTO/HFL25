import 'dart:convert';
import 'dart:io';

import 'dataRespository.dart';
import '../Models/personModel.dart';

class PersonRepository extends DataRepository<Person> {
  PersonRepository([super.filePath = 'storage/person.json']);

  @override
  Person fromJson(Map<String, dynamic> json) => Person.fromJson(json);

  @override
  Map<String, dynamic> toJson(Person item) => item.toJson();

  Person? getPersonById(String id) {
    final persons = getAll();

    /*  print("Searching for: '$id'");
    print("Available IDs: ${persons.map((p) => p.personId).toList()}");
 */
    for (var person in persons) {
      // print("Comparing '${person.personId}' with '$id'");
      if (person.personId.trim().toLowerCase() == id.trim().toLowerCase()) {
        return person; // Found the person, return it.
      }
    }

    // print("Person with ID '$id' not found.");
    return null; // Explicitly return null.
  }

  @override
  String getId(Person person) {
    return person.personId; // Ensure `Person` has an `id` property
  }

  @override
  List<Person> getAll() {
    final file = File(filePath);
    if (!file.existsSync()) return [];
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .map((e) => e != null ? Person.fromJson(e) : null)
        .whereType<Person>() // This removes any null values
        .toList();
  }

  @override
  void update(String personId, Person updateObject) {
    var persons = getAll(); // Fetch all persons

    // Debugging: Print all loaded persons
    print("✅ Loaded persons:");
    for (var person in persons) {
      print("Person ID: ${person.personId}, UUID: ${person.personUuid}");
    }

    // Find index of the person
    final index = persons
        .indexWhere((person) => person.personId == personId);

    print("🔍 Searching for personId: $personId");
    print("🔎 Found index: $index");

    if (index == -1) {
      print("❌ Person with ID $personId not found.");
      return;
    }

    print("✅ Person found at index: $index");

    // Update the person object
    persons[index] = updateObject;
    // persons[index] = updateObject.toLowerCaseFields();
    saveAll(persons);
    print("✅ Update successful!");
  }
}
