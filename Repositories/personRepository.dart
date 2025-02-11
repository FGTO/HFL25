import 'dataRespository.dart';
import '../Models/personModel.dart';

class PersonRepository extends DataRepository<Person> {
  PersonRepository([String filePath = 'Storage/person.json']) : super(filePath);

  @override
  Person fromJson(Map<String, dynamic> json) => Person.fromJson(json);

  @override
  Map<String, dynamic> toJson(Person item) => item.toJson();

  @override
  String getId(Person item) => item.personId;
}