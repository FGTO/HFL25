import 'dart:io';
import 'helperFunctions.dart';
import '../Models/personModel.dart';
import '../Repositories/personRepository.dart';

void userMenu() {
  while (true) {
    stdout.writeln();
    stdout.writeln("Handling user");
    stdout.writeln("1. Create new user");
    stdout.writeln("2. Show all users");
    stdout.writeln("3. Get user by social security number");
    stdout.writeln("4. Update user information");
    stdout.writeln("5. Delete user");
    stdout.writeln("6. Return to main menu");
    stdout.writeln("Choose one option (1-5): ");

    String subChoice = getUserStringInput();

    var personRepo = PersonRepository();
    switch (int.tryParse(subChoice) ?? -1) {
      case 1:
        stdout.write("Enter first name: ");
        String firstName = getUserStringInput();
        stdout.write("Enter surname: ");
        String surname = getUserStringInput();
        stdout.write("Enter mail address: ");
        String email = getUserStringInput();
        stdout.write("Enter  social security number (12 numbers): ");
        String securityNum = getUserStringInput();

        stdout.write(
            "Enter vehicle registration number(s), separated by commas if multiple: ");
        String vehicleInput = getUserStringInput();
        List<String> vehicleIds = vehicleInput.isNotEmpty
            ? vehicleInput.split(',').map((v) => v.trim()).toList()
            : [];

        String fullname = "$firstName $surname.personId";

        Person newAddPerson = Person(
            personId: securityNum,
            name: fullname,
            email: email,
            vehicleIds: vehicleIds);
        personRepo.add(newAddPerson);
        break;
      case 2:
        stdout.writeln("List of users");
        stdout.writeln("__________________________");
        final persons = personRepo.getAll();
        for (var person in persons) {
          print("$person.name $person.se");
        }
        break;
      case 3:
        /* 
        stdout.writeln("Get user by security number");
        stdout.write("Enter user's social security number: ");
        String securityNum = getUserStringInput();
         */
        // personRepo.getPersonById(securityNum);
        return;
      case 4:
        /* 
        stdout.writeln("Update user information");
        stdout.write("Enter user's social security number: ");
        String securityNum = getUserStringInput();
        stdout.write("Enter first name: ");
        String updateFirstName = getUserStringInput();
        stdout.write("Enter surname: ");
        String updateSurname = getUserStringInput();
         */
        // personRepo.updatePerson(securityNum, updateFirstName, updateSurname);
        return;
      case 5:
        /* 
        stdout.writeln("Delete user");
        stdout.writeln("Enter user's social security number to delete: ");
        String securityNumber = getUserStringInput();
         */
        // personRepo.deletePerson(securityNumber);
        return;
      case 6:
        return;
      default:
        stdout.writeln("Something iwent wrong. Try again.");
    }
  }
}
