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

  void update(String id, T updatedItem) {
    final items = getAll();
    final index = items.indexWhere((item) => getId(item) == id);
    if (index != -1) {
      items[index] = updatedItem;
      saveAll(items);
    }
  }

  void delete(String id) {
    final items = getAll();
    items.removeWhere((item) => getId(item) == id);
    saveAll(items);
  }

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);
  String getId(T item);
}