class Person {
  final String personId;
  final String name;
  final String email;
  final List<String> vehicleIds;

  Person({required this.personId, required this.name, required this.email, required this.vehicleIds});

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

/* while (true) {
    stdout.write("Enter a number (1-5) or 'q' to quit: ");
    String? input = stdin.readLineSync();

    if (input == null) {
      continue; // Skip if input is null
    }

    if (input.toLowerCase() == 'q') {
      print("Exiting...");
      break;
    }

    int? number = int.tryParse(input);
    if (number != null && number >= 1 && number <= 5) {
      print("You entered a valid number: $number");
    } else {
      print("Invalid input. Please enter a number between 1 and 5.");
    }
  } */