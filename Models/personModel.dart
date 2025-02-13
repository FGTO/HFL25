class Person {
  final String personId;
  final String name;
  final String email;
  final List<String> vehicleIds;

  Person(
    {required this.personId, 
    required this.name, 
    required this.email, 
    required this.vehicleIds});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        personId: json['personId'],
        name: json['name'],
        email: json['email'],
        vehicleIds: List<String>.from(json['vehicleIds']),
      );

  Map<String, dynamic> toJson() => {
        'personId': personId,
        'name': name,
        'email': email,
        'vehicleIds': vehicleIds,
      };
}
