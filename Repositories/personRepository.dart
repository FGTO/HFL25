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
}
