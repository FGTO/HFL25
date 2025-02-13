import 'dart:io';
import '../utils/helperFunctions.dart';
import '../repositories/personRepository.dart';
import '../Models/personModel.dart';
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
    stdout.writeln("Choose one option (1-6): ");

    String menuChoice = getUserStringInput();
    int? menuNum = int.tryParse(menuChoice);
    if (menuNum != null && menuNum >= 1 && menuNum <= 6) {
      var personRepo = PersonRepository();
      switch (menuNum) {
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

          String fullname = "$firstName $surname";

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
            print("${person.name} ${person.personId}");
          }
          break;
        case 3:
          stdout.writeln("Get user by security number");
          stdout.write("Enter user's social security number (YYYYMMDD-XXXX): ");
          String securityNum = getUserStringInput();
          final person = personRepo.getPersonById(securityNum);
          if (person != null) {
            print('Found: ${person.name} - ${person.email}');
          } else {
            print('Person not found.');
          }
          break;
        case 4:
          stdout.writeln("Update user information");
          stdout.write("Enter user's social security number: ");
          String securityNum = getUserStringInput();

          final person = personRepo.getPersonById(securityNum);
          if (person != null) {
            stdout.write("Enter new firstname: ");
            String newFirstName = getUserStringInput();
            stdout.write("Enter new surname: ");
            String newSurname = getUserStringInput();
            stdout.write("Enter new mail address: ");
            String newEmail = getUserStringInput();
            String newFullname = "$newFirstName $newSurname";
            Person updatedPerson = Person(
                personId: securityNum,
                name: newFullname,
                email: newEmail,
                vehicleIds: person.vehicleIds);
            personRepo.update(securityNum, updatedPerson);
          } else {
            print('Security number not found.');
          }
          break;
        case 5:
          stdout.writeln("Delete user");
          stdout.writeln("Enter user's social security number to delete: ");
          String sec = getUserStringInput().trim();
          final person = personRepo.getPersonById(sec);

          if (person != null) {
            stdout.write("Are you sure you want to delete: ");
            stdout.write('Deleting : ${person.name} - ${person.email} ? (y/n)');
            String deleting = getUserStringInput();
            if (deleting.toLowerCase() == 'y') {
              personRepo.delete(sec);
            } else {
              print("Can't find anyone with this social security number.");
              break;
            }
            break;
          }
        case 6:
          return;
        default:
          stdout.writeln("Something went wrong. Try again.");
      }
    }else{
      print("Incorrect input. Try again.");
    }
  }
}
