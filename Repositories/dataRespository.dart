library dataRepository;

import 'dart:convert';
import 'dart:io';

abstract class DataRepository<T> {
  final String filePath;

  DataRepository(this.filePath);

  List<T> getAll() {
    final file = File(filePath);
    if (!file.existsSync()) return [];
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((e) => fromJson(e)).toList();
  }

  void saveAll(List<T> items) {
    final file = File(filePath);
    final jsonString = json.encode(items.map((e) => toJson(e)).toList());
    file.writeAsStringSync(jsonString);
  }

  void add(T item) {
    final items = getAll();
    items.add(item);
    saveAll(items);
  }

void update(String personId, T updateObject) {
  var persons = getAll(); // Fetch the list from JSON file

  // Debugging: Print all loaded persons
  print("✅ Loaded persons:");
  for (var person in persons) {
    print(person);  // Ensure the structure is correct
  }

  final index = persons.indexWhere(
    (person) =>
        person is Map<String, dynamic> && 
        person['personId'].toString() == personId,
  );

  print("🔍 Searching for personId: $personId");
  print("🔎 Found index: $index");

  if (index == -1) {
    print("❌ Person with ID $personId not found.");
    return;
  }

  print("✅ Person found at index: $index");
}

/* void update(String personId, T updateObject) {
  var persons = getAll();

  // Convert personId to a string and check against the JSON values
  final index = persons.indexWhere(
    (person) =>
        person is Map<String, dynamic> &&
        person['personId'].toString() == personId,
  );

  print("Person index for $personId is: $index");

  if (index == -1) {
    print("❌ Person with ID $personId not found.");
    return;
  }

  print("✅ Person found at index: $index");
}
 */

/*   void update(String id, dynamic updatedItem) {
    final items = getAll();
    final index = items.indexWhere((item) => getId(item) == id);

    if (index != -1) {
      items[index] =
          updatedItem.toLowerCaseFields(); // Ensure lowercase before saving
      saveAll(items);
      print("Update successful!");
    } else {
      print("Person not found!");
    }
  } */

  void delete(String id) {
    final items = getAll();
    int initialLength = items.length;
    items.removeWhere((item) {
      bool shouldRemove = getId(item).trim() == id.trim();
      /* print(
          "Checking: '${getId(item)}' == '$id' -> ${shouldRemove ? 'REMOVING' : 'KEEPING'}");
      */
      return shouldRemove;
    });

    if (items.length == initialLength) {
      print("❌ No item was removed! Make sure IDs match.");
    } else {
      print("✅ Entry removed successfully.");
    }

    print("After delete: ${items.map((e) => getId(e)).toList()}"); // Debugging

    saveAll(items); // Save back to JSON file
  }

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);
  String getId(T item);
}

