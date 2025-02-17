
class Person {
  final String personUuid;
  final String personId;
  final String firstName;
  final String surname;
  final String email;
  final List<String>? vehicleIds;

  Person({
    required this.personUuid,
    required this.personId,
    required this.firstName,
    required this.surname,
    required this.email,
    required this.vehicleIds,
  });

factory Person.fromJson(Map<String, dynamic> json) {
  return Person(
    personUuid: json['personUuid'] ?? '',  
    personId: json['personId'] ?? '',      
    firstName: json['firstName'] ?? '', 
    surname: json['surname'] ?? '',
    email: json['email'] ?? '',
    vehicleIds: (json['vehicleIds'] as List<dynamic>?)?.cast<String>() ?? [],
  );
}

  Map<String, dynamic> toJson() => {
    'personUuid':personUuid,
        'personId': personId,
        'firstName' : firstName,
        'surname':surname,
        'email': email,
        'vehicleIds': vehicleIds,
      };

  Person toLowerCaseFields() {
    return Person(
      personUuid : personUuid,
      personId: personId, 
      firstName: firstName.toLowerCase(),
      surname: surname.toLowerCase(),
      email: email.toLowerCase(),
      vehicleIds: vehicleIds, 
    );
  }
}
