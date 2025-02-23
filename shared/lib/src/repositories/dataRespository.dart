import 'dart:convert';
import 'dart:io';

abstract class DataRepository<T> {
  final String filePath;

  DataRepository(this.filePath);

  Future<List<T>> getAll() async {
    final file = File(filePath);
    if (!file.existsSync()) return [];
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((e) => fromJson(e)).toList();
  }

  Future<void> saveAll(List<T> items) async {
    final file = File(filePath);
    final jsonString = json.encode(items.map((e) => toJson(e)).toList());
    file.writeAsStringSync(jsonString);
  }

  Future< void> create(T item) async {
    final items = await getAll();
    items.add(item);
    await saveAll(items);
  }

Future<void> update(String personId, T updateObject) async {
  var persons = await getAll(); // Fetch the list from JSON file

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

 Future<void> delete(String id) async {
    final items = await getAll();
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

